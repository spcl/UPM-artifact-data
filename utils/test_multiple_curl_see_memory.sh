#!/bin/bash

# /root/
# ./test_multiple_curl_see_memory.sh 411.image-recognition 5
benchmark=$1
request_times=$2
container_num=1
# read -p "is dedup is on?" dedup

# if [ ! -d "/data/$benchmark" ]; then
#     mkdir /data/$benchmark/
# fi

# if [[ "$dedup" == "1" ]]; then
#     if [ ! -d "/data/$benchmark/concurrent_containers_dedupon" ]; then
#         mkdir /data/$benchmark/concurrent_containers_dedupon
#     fi
#     data_dir="/data/$benchmark/concurrent_containers_dedupon"
# fi

# if [[ "$dedup" == "0" ]]; then
#     if [ ! -d "/data/$benchmark/concurrent_containers_dedupoff" ]; then
#         mkdir /data/$benchmark/concurrent_containers_dedupoff
#     fi
#     data_dir="/data/$benchmark/concurrent_containers_dedupoff"
# fi

utils_dir="/root/utils"

docker stop `docker ps -a -q`
docker rm `docker ps -a -q`
j=1

read -p "output_dir:" dir
mkdir /root/${dir}
# start and curl new containers
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
docker_pid=`docker inspect -f '{{.State.Pid}}' ${docker_name}`
curl_cmd() {
    curl 172.17.0.$ip:9000 --request POST --data "$input" --header 'Content-Type:application/json' #>> /root/curl_${benchmark}/curl_result${j}.txt
}
for ((n=1; n<=request_times; n++))
do
    echo "times: $n"
    curl_cmd
    sudo pmap -X ${docker_pid} >> /root/${dir}/pmap_curl${n}.txt
    sudo pmap -X ${docker_pid} | (head -n2 && tail -n1)
done
