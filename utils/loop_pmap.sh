#!/bin/bash

# /root/utils/loop_pmap.sh /data/411.image-recognition/curl_container1 pmap_result.csv

data_dir=$1
out_file_name=$2

cd $data_dir

# if [ -f "$out_file_name" ]; then
#     echo "$out_file_name already exists"
#     exit
# fi

# iterate over all pmap txt
for filename in `ls pmap*.txt | sort -V`
do
    $UTILS_DIR/parse_pmap.sh $filename $out_file_name
    echo $filename
done
