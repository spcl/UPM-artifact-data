#!/bin/bash


benchmark=$1
request_times=$2
aslr=$3 # 1 means alsr is on, 0 means aslr is off

# same_data_dir="/root/$benchmark/aslr${aslr}/same_input_two_containers"
diff_data_dir="/data/$benchmark/aslr${aslr}/diff_input_two_containers"
# diff_data_dir="/data"
mkdir /data/$benchmark
mkdir /data/$benchmark/aslr${aslr}
# mkdir /data/$benchmark/aslr${aslr}/same_input_two_containers
mkdir /data/$benchmark/aslr${aslr}/diff_input_two_containers

command_dir1="/root/serverless-benchmarks1"
command_dir2="/root/serverless-benchmarks2"
utils_dir="/root/utils"

# echo "testing with same input..."
# for ((j=1; j<=2; j++))
# do
#     if [[ "$j" == "1" ]]; then
#         cd $command_dir1
#     else
#         cd $command_dir2
#     fi
#     source ./sebs-virtualenv/bin/activate
#     ./sebs.py local start $benchmark large two_containers_test_out.json --config config/example.json --deployments 1 --verbose --no-remove-containers
#     docker_name=`docker ps | awk '{print $NF}' | awk 'NR==2{print}'`
#     # read -p "input:" input
#     input=`python3 $utils_dir/get_curl_input.py /root/serverless-benchmarks${j}/two_containers_test_out.json`
#     ip=$((2*j+1))
#     echo "Curling container $j $docker_name with ip 172.17.0.${ip}..."
#     curl_cmd() {
#         curl 172.17.0.$ip:9000 --request POST --data "$input" --header 'Content-Type:application/json'
#     }
#     for ((n=1; n<=request_times; n++))
#     do
#         curl_cmd
#     done
# done

# #get pmap
# for ((k=1; k<=2; k++))
# do
#     docker_order=$((k*2))
#     name=`docker ps | tail -n${docker_order} | head -n1 | awk '{print $NF}'`
#     docker_pid=`docker inspect -f '{{.State.Pid}}' ${name}`
#     echo "writing pmap${k}.txt"
#     sudo pmap -XX ${docker_pid} >> ${same_data_dir}/pmap${k}.txt
# done

# #checkpointing
# docker_name1=`docker ps | tail -n2 | head -n1 | awk '{print $NF}'`
# docker_name2=`docker ps | tail -n4 | head -n1 | awk '{print $NF}'`
# docker checkpoint create ${docker_name1} c1 --checkpoint-dir=${same_data_dir}
# docker checkpoint create ${docker_name2} c2 --checkpoint-dir=${same_data_dir}

docker stop `docker ps -a -q`
docker rm `docker ps -a -q`


echo "testing with different input..."
for ((j=1; j<=2; j++))
do
    if [[ "$j" == "1" ]]; then
        cd $command_dir1
    else
        cd $command_dir2
    fi
    source ./sebs-virtualenv/bin/activate
    ./sebs.py local start $benchmark large two_containers_test_out.json --config config/example.json --deployments 1 --verbose --no-remove-containers
    docker_name=`docker ps | awk '{print $NF}' | awk 'NR==2{print}'`
    # read -p "input:" input
    input=`python3 $utils_dir/get_curl_input.py /root/serverless-benchmarks${j}/two_containers_test_out.json`
    ip=$((2*j+1))
    echo "Curling container $j $docker_name with ip 172.17.0.${ip}..."
    curl_cmd() {
        curl 172.17.0.$ip:9000 --request POST --data "$input" --header 'Content-Type:application/json'
    }
    for ((n=1; n<=request_times; n++))
    do
        curl_cmd
    done
done

#get pmap
# for ((k=1; k<=2; k++))
# do
#     docker_order=$((k*2))
#     name=`docker ps | tail -n${docker_order} | head -n1 | awk '{print $NF}'`
#     docker_pid=`docker inspect -f '{{.State.Pid}}' ${name}`
#     cat /proc/$docker_pid/status | grep Vm >> $diff_data_dir/peak_current_rss${k}.txt
#     echo "writing pmap${k}.txt to ${diff_data_dir}"
#     sudo pmap -XX ${docker_pid} >> ${diff_data_dir}/pmap${k}.txt
# done

#checkpointing
# docker_name1=`docker ps | tail -n2 | head -n1 | awk '{print $NF}'`
# docker_name2=`docker ps | tail -n4 | head -n1 | awk '{print $NF}'`
# docker checkpoint create ${docker_name1} c1 --checkpoint-dir=${diff_data_dir}
# docker checkpoint create ${docker_name2} c2 --checkpoint-dir=${diff_data_dir}

# docker stop `docker ps -a -q`
# docker rm `docker ps -a -q`

# deal with the data
# deal with checkpoint data
# for ((i=1; i<=1; i++))
# do
#     # if [[ "$i" == "1" ]]; then
#     #     cd $same_data_dir
#     #     $utils_dir/loop_pmap.sh $same_data_dir pmap_result.csv
#     # else
#     #     cd $diff_data_dir
#     #     $utils_dir/loop_pmap.sh $diff_data_dir pmap_result.csv
#     # fi

#     #deal with pmap data
#     cd $diff_data_dir
#     $utils_dir/loop_pmap.sh $diff_data_dir pmap_result.csv

#     python3 $utils_dir/cmp_page_hash.py c1/pages-1.img c2/pages-1.img 1
#     identical_pages=`cat cmp_out.txt | wc -l`
#     file1_identical=`cat file1_out.txt | wc -l`
#     file2_identical=`cat file2_out.txt | wc -l`
#     rm cmp_out.txt file1_out.txt file2_out.txt

#     python3 $utils_dir/cmp_page_hash.py c1/pages-1.img c2/pages-1.img 8
#     similar_pages75=`cat cmp_out.txt | awk '{print $9}' | cut -d'-' -f1 | sort | uniq -c | sort -nr | awk '$1>=6 && $1<8' | wc -l`
#     similar_pages50=`cat cmp_out.txt | awk '{print $9}' | cut -d'-' -f1 | sort | uniq -c | sort -nr | awk '$1>=4 && $1<8' | wc -l`
#     rm cmp_out.txt file1_out.txt file2_out.txt

#     echo "identical page,75,50" >> checkpoint_result.csv
#     echo "${identical_pages},${similar_pages75},${similar_pages50}" >> checkpoint_result.csv
    
#     cd $diff_data_dir
#     $utils_dir/get_anonymous_filebacked_data.sh  
    
# done

