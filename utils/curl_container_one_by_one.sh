#!/bin/bash

# used with launch_without_curl_containers.sh

benchmark="411.image-recognition"
utils_dir="/root/utils"

for ((j=1; j<=16; j++))
do
    #read -p "curl container $j?" container
    input=`python3 $utils_dir/get_curl_input.py /root/serverless-benchmarks${j}/out.json`
    ip=$((2*j+1))
    curl 172.17.0.$ip:9000 --request POST --data "$input" --header 'Content-Type:application/json'
    echo -e "\n"
done
