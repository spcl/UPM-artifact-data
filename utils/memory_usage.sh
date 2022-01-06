#!/bin/bash

# /root/
# ./memory_usage.sh image-recognition 5 16 einstein_vm
request_times=5

read -p "is dedup is on?" dedup

# if [ ! -d "/data/$BENCHMARK" ]; then
#     mkdir /data/$BENCHMARK/
# fi

dedup_on_data_dir="/root/usm_plot_data_needed/$MACHINE/memory_usage/$BENCHMARK/function_memory/dedup_on"
dedup_off_data_dir="/root/usm_plot_data_needed/$MACHINE/memory_usage/$BENCHMARK/function_memory/dedup_off"

if [[ "$dedup" == "1" ]]; then
    if [ ! -d "$dedup_on_data_dir" ]; then
        mkdir $dedup_on_data_dir
    fi
    data_dir=$dedup_on_data_dir
fi

if [[ "$dedup" == "0" ]]; then
    if [ ! -d $dedup_off_data_dir ]; then
        mkdir $dedup_off_data_dir
    fi
    data_dir=$dedup_off_data_dir
fi


docker stop `docker ps -a -q`
docker rm `docker ps -a -q`

echo "0 container:" > $data_dir/system_memory_usage.txt
free >>  $data_dir/system_memory_usage.txt

for ((i=1; i<=CONTAINER_NUM; i=i*2))
do
    echo "concurrent $i containers"q
    # echo "making dir $data_dir/$i"
    mkdir $data_dir/$i
    # start and curl new containers
    for ((j=i/2+1; j<=i; j++))
    do
        echo "starting container $j"
        command_dir=/root/serverless-benchmarks${j}
        cd $command_dir
        source ./python-venv/bin/activate
        ./sebs.py local start 411.$BENCHMARK large concurrenttest_out.json --config config/example.json --deployments 1 --verbose --no-remove-containers
        docker_name=`docker ps | awk '{print $NF}' | awk 'NR==2{print}'`
        # read -p "input of container ${j}:" input
        input=`python3 $UTILS_DIR/get_curl_input.py /root/serverless-benchmarks${j}/concurrenttest_out.json`
        echo $input
        ip=$((2*j+1))
        # echo "Curling container $j $docker_name with ip 172.17.0.${ip}..."
        # mkdir /root/curl_${BENCHMARK}
        curl_cmd() {
            curl 172.17.0.$ip:9000 --request POST --data "$input" --header 'Content-Type:application/json' #>> /root/curl_${BENCHMARK}/curl_result${j}.txt
        }
        for ((n=1; n<=request_times; n++))
        do
            curl_cmd
        done
        if [[ "$i" == "16" ]]; then
            input=`python3 $UTILS_DIR/get_curl_input.py /root/serverless-benchmarks1/concurrenttest_out.json`
            curl 172.17.0.3:9000 --request POST --data "$input" --header 'Content-Type:application/json'
            input=`python3 $UTILS_DIR/get_curl_input.py /root/serverless-benchmarks2/concurrenttest_out.json`
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

    echo "$i container:" >> $data_dir/system_memory_usage.txt
    free >>  $data_dir/system_memory_usage.txt
done

# parse the pmap files
cd $data_dir
for concurrent_dir in `ls | sort -V`
do
    if [[ "$concurrent_dir" == "system_memory_usage.txt" ]]
    then
        continue
    fi
    $UTILS_DIR/loop_pmap.sh $data_dir/$concurrent_dir pmap_result${concurrent_dir}.csv
done

deactivate
# python3 ${UTILS_DIR}/plot_concurrent.py $BENCHMARK $CONTAINER_NUM $dedup
