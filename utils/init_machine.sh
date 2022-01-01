#!/bin/bash

#eg: ./init_machine.sh einstein_vm
machine=$1
mkdir /root/usm_plot_data_needed/$machine
mkdir /root/usm_plot_data_needed/$machine/time_cost
mkdir /root/usm_plot_data_needed/$machine/memory_usage
mkdir /root/usm_plot_data_needed/$machine/memory_usage/image-recognition
mkdir /root/usm_plot_data_needed/$machine/memory_usage/image-recognition/function_memory
mkdir /root/usm_plot_data_needed/$machine/memory_usage/image-recognition/system_memory
mkdir /root/usm_plot_data_needed/$machine/sharing_potential
mkdir /root/usm_plot_data_needed/$machine/time_cost/image-recognition
mkdir /root/usm_plot_data_needed/$machine/time_cost/micro-benchmark
