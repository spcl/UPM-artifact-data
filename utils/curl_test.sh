#!/bin/bash

benchmark=$1
times=$2

#  ~/utils/curl_test.sh 411.image-recognition 2000
# ~/utils/curl_test.sh 210.thumbnailer 2000
# ~/utils/curl_test.sh 504.dna-visualisation 2000

mkdir /data/$benchmark/
mkdir /data/$benchmark/curl_container1
mkdir /data/$benchmark/curl_container2

data_dir1="/data/$benchmark/curl_container1"
data_dir2="/data/$benchmark/curl_container2"
command_dir1="/root/serverless-benchmarks1"
command_dir2="/root/serverless-benchmarks2"
utils_dir="/root/utils"

# start containers
cd $command_dir1
source ./sebs-virtualenv/bin/activate
./sebs.py local start $benchmark large curltest_out.json --config config/example.json --deployments 1 --verbose --no-remove-containers
docker_name1=`docker ps | awk '{print $NF}' | awk 'NR==2{print}'`
echo "Container 1: $docker_name1"
read -p "input1:" input1


cd $command_dir2
source ./sebs-virtualenv/bin/activate
./sebs.py local start $benchmark large curltest_out.json --config config/example.json --deployments 1 --verbose --no-remove-containers
docker_name2=`docker ps | awk '{print $NF}' | awk 'NR==2{print}'`
echo "Container 2: $docker_name2"
read -p "input2:" input2

echo ""

print=1

# invoking the functions
for ((i=1; i<=times; i++))
do
    docker_pid1=`docker inspect -f '{{.State.Pid}}' ${docker_name1}`
    docker_pid2=`docker inspect -f '{{.State.Pid}}' ${docker_name2}`

    curl 172.17.0.3:9000 --request POST --data "$input1" --header 'Content-Type: application/json' #>> /dev/null
    curl 172.17.0.5:9000 --request POST --data "$input2" --header 'Content-Type: application/json' #>> /dev/null

    # if [[ "$i" == "$print" || "$i" == "1" ]]; then
    if [[ "$i" == "$print" ]]; then
        sudo pmap -XX ${docker_pid1} >> ${data_dir1}/pmap${i}.txt
        sudo pmap -XX ${docker_pid2} >> ${data_dir2}/pmap${i}.txt

        docker checkpoint create ${docker_name1} c${i}
        docker checkpoint create ${docker_name2} c${i}

        container_id1_short=`docker ps -a | grep $docker_name1 | awk '{print $1}'`
        # echo "container_id1_short： ${container_id1_short}"
        container_id1=`ls /var/lib/docker/containers | grep $container_id1_short`
        # echo $container_id1
        cp -r /var/lib/docker/containers/${container_id1}/checkpoints/c${i} ${data_dir1}/

        container_id2_short=`docker ps -a | grep $docker_name2 | awk '{print $1}'`
        container_id2=`ls /var/lib/docker/containers | grep $container_id2_short`
        cp -r /var/lib/docker/containers/${container_id2}/checkpoints/c${i} ${data_dir2}/

        # print=$((print*2))
        # print=$((print+100))
        print=$((print+1))
        echo "iteration $i is being recorded"

        docker start --checkpoint c${i} ${docker_name1}
        echo "container ${docker_name1} has been restarted"
        docker start --checkpoint c${i} ${docker_name2}
        echo "container ${docker_name2} has been restarted"
        echo ""
    fi

done

echo "DON'T FORGET TO SAVE THE CHECKPOINT FILES!! THEY WILL BE DELETED IF THE CONTAINER GETS REMOVED!!"
echo "OR CHECK IF THE COPIED CHECKPOINT FILES ARE CORRECT!!!"

