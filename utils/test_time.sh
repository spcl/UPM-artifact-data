#!/bin/bash

# ./test_time.sh $repeated_times $machine
# eg: ./test_time.sh 10 einstein_vm


######################### FTRACE #############################
# ./test_time.sh 1
# 1: ftrace on, 2: ftrace off, measure function execution time
# ftrace_on=$1

# read -p "file_name?" file_name
# sysctl kernel.ftrace_enabled=1
# mount -t tracefs nodev /sys/kernel/tracing
##############################################################

benchmark="411.image-recognition"
repeated_time=$1
machine=$2


utils_dir="/root/utils"


for ((i=1; i<=repeated_time; i++))
do
    docker stop `docker ps -a -q` > /dev/null
    docker rm `docker ps -a -q` > /dev/null
    echo "${i}th iteration"
    for ((j=1; j<=16; j++))
    do
        echo "starting container $j"
        command_dir=/root/serverless-benchmarks${j}
        cd $command_dir
        source ./python-venv/bin/activate
        ./sebs.py local start $benchmark large myout.json --config config/example.json --deployments 1 --verbose --no-remove-containers
        docker_name=`docker ps | awk '{print $NF}' | awk 'NR==2{print}'`
        # read -p "input of container ${j}:" input
        input=`python3 $utils_dir/get_curl_input.py /root/serverless-benchmarks${j}/myout.json`
        # echo $input
        ip=$((2*j+1))
        
        curl_cmd() {
            curl 172.17.0.$ip:9000 --request POST --data "$input" --header 'Content-Type:application/json' #>> /root/curl_${benchmark}/curl_result${j}.txt
        }

        # if [[ "$ftrace_on" == "1" ]]
        # then
        #     cd ~/
        #     echo "ftrace is on"
        #     mkdir ~/ftrace_data

        #     cd /sys/kernel/tracing
        #     echo nop > current_tracer
        #     echo 0 > tracing_on
        #     echo function_graph > current_tracer
        #     echo usm_madvise > set_graph_function
        #     echo usm_exit >> set_graph_function
        #     echo 1 > tracing_on
        #     curl_cmd
        #     echo 0 > tracing_on
        #     echo funcgraph-abstime > trace_options
        #     echo funcgraph-proc > trace_options
        #     echo nofuncgraph-overhead > trace_options
        #     cat trace > ~/ftrace_data/trace-data${j}.txt
        # fi

        # if [[ "$ftrace_on" == "2" ]]
        # then
            # echo "ftrace is off"

        out_file="/root/usm_plot_data_needed/$machine/time_cost/image-recognition/times$i/container$j.json"
        mkdir /root/usm_plot_data_needed/$machine/time_cost/image-recognition/times$i
        if [ ! -f "$out_file" ]; then
            curl_cmd > $out_file
        else
            curl_cmd >> $out_file
        fi
        # fi

        # read -p "finish?" finish
    done
done

