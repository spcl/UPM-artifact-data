#!/bin/bash

input_file=$1 # the output result file
page_num=$2 # number of pages in file 2
count=0
for ((i=1;i<=page_num;i++))
do
	line_num=`cat ${input_file} | grep "file 2 page${i}" | wc -l`
	if [ $line_num -ge 3 -a $line_num -lt 8 ]; then
		count=$((count+1))
	fi
done
echo ${count}	
