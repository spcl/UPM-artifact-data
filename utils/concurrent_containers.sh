#!/bin/bash

# /root/
# ./concurrent_containers.sh 411.image-recognition 5 16
benchmark=$1
request_times=$2
container_num=$3

read -p "is dedup is on?" dedup

if [ ! -d "/data/$benchmark" ]; then
    mkdir /data/$benchmark/
fi

if [[ "$dedup" == "1" ]]; then
    if [ ! -d "/data/$benchmark/concurrent_containers_dedupon" ]; then
        mkdir /data/$benchmark/concurrent_containers_dedupon
    fi
    data_dir="/data/$benchmark/concurrent_containers_dedupon"
fi

if [[ "$dedup" == "0" ]]; then
    if [ ! -d "/data/$benchmark/concurrent_containers_dedupoff" ]; then
        mkdir /data/$benchmark/concurrent_containers_dedupoff
    fi
    data_dir="/data/$benchmark/concurrent_containers_dedupoff"
fi

utils_dir="/root/utils"

docker stop `docker ps -a -q`
docker rm `docker ps -a -q`

for ((i=1; i<=container_num; i=i*2))
do
    echo "concurrent $i containers"
    # echo "making dir $data_dir/$i"
    mkdir $data_dir/$i
    # start and curl new containers
    for ((j=i/2+1; j<=i; j++))
    do
        echo "starting container $j"
        command_dir=/root/serverless-benchmarks${j}
        cd $command_dir
        source ./sebs-virtualenv/bin/activate
        ./sebs.py local start $benchmark large concurrenttest_out.json --config config/example.json --deployments 1 --verbose --no-remove-containers
        docker_name=`docker ps | awk '{print $NF}' | awk 'NR==2{print}'`
        # read -p "input of container ${j}:" input
        input=`python3 $utils_dir/get_curl_input.py /root/serverless-benchmarks${j}/concurrenttest_out.json`
        echo $input
        ip=$((2*j+1))
        # echo "Curling container $j $docker_name with ip 172.17.0.${ip}..."
        # mkdir /root/curl_${benchmark}
        curl_cmd() {
            curl 172.17.0.$ip:9000 --request POST --data "$input" --header 'Content-Type:application/json' #>> /root/curl_${benchmark}/curl_result${j}.txt
        }
        for ((n=1; n<=request_times; n++))
        do
            curl_cmd
        done
        if [[ "$i" == "16" ]]; then
            input=`python3 $utils_dir/get_curl_input.py /root/serverless-benchmarks1/concurrenttest_out.json`
            curl 172.17.0.3:9000 --request POST --data "$input" --header 'Content-Type:application/json'
            input=`python3 $utils_dir/get_curl_input.py /root/serverless-benchmarks2/concurrenttest_out.json`
            curl 172.17.0.5:9000 --request POST --data "$input" --header 'Content-Type:application/json'
        fi
        echo ""
    done
    # now the container has already been there, and has been curled, we need to get the pmap result
    for ((k=1; k<=i; k++))
    do
        docker_order=$((k*2))
        name=`docker ps | tail -n${docker_order} | head -n1 | awk '{print $NF}'`
        docker_pid=`docker inspect -f '{{.State.Pid}}' ${name}`
        echo "writing pmap${k}.txt"
        sudo pmap -XX ${docker_pid} >> ${data_dir}/${i}/pmap${k}.txt
    done

done

# parse the pmap files
cd $data_dir
for concurrent_dir in `ls | sort -V`
do
    if [[ "$concurrent_dir" == "concurrent.jpg" ]]
    then
        continue
    fi
    $utils_dir/loop_pmap.sh $data_dir/$concurrent_dir pmap_result${concurrent_dir}.csv
done

deactivate
python3 ${utils_dir}/plot_concurrent.py $benchmark $container_num $dedup
