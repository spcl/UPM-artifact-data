#!/bin/bash

read -p "1 or 2?" first

mkdir /root/usm_plot_data_needed/cscs_vm
mkdir /root/usm_plot_data_needed/cscs_vm/time_cost
mkdir /root/usm_plot_data_needed/cscs_vm/time_cost/micro-benchmark

begin=64
end=2048
interval=64

data_dir="/root/usm_plot_data_needed/cscs_vm/time_cost/micro-benchmark"
for ((s=begin; s<=end; s=s+interval))
do
    echo "Size:${s}MB"
    for ((i=1; i<=10; i=i+1))
    do
        if [ "$first" == "1" ]; then
            ./micro_repeat $s >> $data_dir/${s}add.csv
        else
            ./micro_repeat $s >> $data_dir/${s}share.csv
        fi
    done
done
