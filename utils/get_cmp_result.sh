#!/bin/bash

# /root/utils/get_cmp_result.sh /data/$benchmark/ 11
c1_dir=$1
c2_dir=$2
benchmark=$3
utils_dir="/root/utils"
data_dir="/data/$benchmark"

out_file_name="identicalpage_result.csv"


cd $data_dir

if [ -f "$out_file_name" ]; then
    echo "$out_file_name already exists"
    exit
fi

echo "checkpoint number,identical page num,75% similar,50% similar" >> $out_file_name

#for ((i=1; i<=loop_num; i++))
cd $c1_dir
for checkpoint_dir in `ls -d c* | sort -V`
do
    echo "checking ${checkpoint_dir}:"
    python3 $utils_dir/cmp_page_hash.py $c1_dir/$checkpoint_dir/pages-1.img $c2_dir/$checkpoint_dir/pages-1.img 1

    identical_pages=`cat cmp_out.txt | wc -l`
    file1_identical=`cat file1_out.txt | wc -l`
    file2_identical=`cat file2_out.txt | wc -l`

    # echo "identical pages: ${identical_pages}"
    # echo "file1_identical: ${file1_identical}"
    # echo "file2_identical: ${file2_identical}"

    rm cmp_out.txt file1_out.txt file2_out.txt

    python3 $utils_dir/cmp_page_hash.py $c1_dir/$checkpoint_dir/pages-1.img $c2_dir/$checkpoint_dir/pages-1.img 8

    similar_pages75=`cat cmp_out.txt | awk '{print $9}' | cut -d'-' -f1 | sort | uniq -c | sort -nr | awk '$1>=6 && $1<8' | wc -l`
    similar_pages50=`cat cmp_out.txt | awk '{print $9}' | cut -d'-' -f1 | sort | uniq -c | sort -nr | awk '$1>=4 && $1<8' | wc -l`

    # echo "75% similar pages: ${similar_pages75}"
    # echo "50% similar pages: ${similar_pages50}"
    # echo ""
    rm cmp_out.txt file1_out.txt file2_out.txt

    echo "${checkpoint_dir},${identical_pages},${similar_pages75},${similar_pages50}" >> $data_dir/$out_file_name
    
done
