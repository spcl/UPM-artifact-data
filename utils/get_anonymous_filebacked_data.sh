#!/bin/bash

# for example, in same_input_two_contianers dir

utils_dir="/root/utils"
python3 $utils_dir/cmp_page_hash.py c1/pages-1.img c2/pages-1.img 1

# cut -d:delimiter, -f: get field
awk '{print $9}' cmp_out.txt | cut -d '-' -f 1 | grep -oP "[0-9]+" >> identical_page_file.csv

rm cmp_out.txt file1_out.txt file2_out.txt

crit decode -i c2/pagemap-1.img --pretty >> pagemap.json

python3 $utils_dir/seperate_anonymous_filebacked_from_checkpoint.py pagemap.json identical_page_file.csv