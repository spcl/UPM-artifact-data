#!/bin/bash

utils_dir="/root/utils"
data_dir="/data"
benchmark=$1
curl_times=$2

# 0. stop all running containers
docker stop `docker ps -a -q`
docker rm `docker ps -a -q`

# 1. deal with curl N requests' result
$utils_dir/curl_test.sh $benchmark $curl_times

# pmap_result will contain rss etc of each request in curl_container1, 
# the result is stored in pmap_result.csv
$utils_dir/loop_pmap.sh $data_dir/$benchmark/curl_container1 pmap_result.csv
$utils_dir/loop_pmap.sh $data_dir/$benchmark/curl_container2 pmap_result.csv

# Then get the shareable pages number in the checkpoints
/root/utils/get_cmp_result.sh $data_dir/$benchmark/curl_container1 $data_dir/$benchmark/curl_container2 $benchmark

# Then draw the plot
cd $data_dir/$benchmark/curl_container1
python3 $utils_dir/plot_curl.py

