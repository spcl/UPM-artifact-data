#!/bin/bash

input_file=$1
output_file_dir=$2
if [ ! -d "$output_file_dir" ]; then
	mkdir "$output_file_dir"
fi
size=`ls -l $input_file | awk '{print $5}'`
page_num=$((size/4096))

for ((i=1;i<=page_num;i++))
do
	dd if=$input_file of=${output_file_dir}/page${i}.img bs=4k skip=$((i-1)) count=1
	echo "page${i} is produced"
done
