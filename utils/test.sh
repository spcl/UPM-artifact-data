#!/bin/bash
aslr=$1

benchmark="411.image-recognition"
utils_dir="/root/utils"
data_dir="/data/$benchmark/concurrent_containers"
same_data_dir="/data/$benchmark/aslr${aslr}/same_input_two_containers"
diff_data_dir="/data/$benchmark/aslr${aslr}/diff_input_two_containers"

for ((i=1; i<=2; i++))
do
    if [[ "$i" == "1" ]]; then
        cd $same_data_dir
    else
        cd $diff_data_dir
    fi
    pwd
    python3 $utils_dir/cmp_page_hash.py c1/pages-1.img c2/pages-1.img 1
    identical_pages=`cat cmp_out.txt | wc -l`
    file1_identical=`cat file1_out.txt | wc -l`
    file2_identical=`cat file2_out.txt | wc -l`
    rm cmp_out.txt file1_out.txt file2_out.txt

    python3 $utils_dir/cmp_page_hash.py c1/pages-1.img c2/pages-1.img 8
    similar_pages75=`cat cmp_out.txt | awk '{print $9}' | cut -d'-' -f1 | sort | uniq -c | sort -nr | awk '$1>=6 && $1<8' | wc -l`
    similar_pages50=`cat cmp_out.txt | awk '{print $9}' | cut -d'-' -f1 | sort | uniq -c | sort -nr | awk '$1>=4 && $1<8' | wc -l`
    rm cmp_out.txt file1_out.txt file2_out.txt

    echo "identical page, 75, 50" >> checkpoint_result.csv
    echo "${identical_pages},${similar_pages75},${similar_pages50}" >> checkpoint_result.csv

    #deal with pmap data
    # $utils_dir/loop_pmap.sh ./ pmap_result.csv
done
