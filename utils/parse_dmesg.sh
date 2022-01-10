#!/bin/bash

# dmesg -c > 
cd ~/usm_function_time_high_level
out_file="high_level_time.csv"
for ((i=1; i<=16; i++))
do
    read -p "container $i ready?" input   
    dmesg > ~/usm_function_time_high_level/dmesg${i}.csv
    dmesg -c > /dev/null

    # search_time=`cat dmesg${i}.csv | head -n -1 | awk 'BEGIN {FS = " "} ; {sum+=$3} END {print sum}'`
    # add_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$5} END {print sum}'`
    # replace_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$7} END {print sum}'`
    # spin_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$9} END {print sum}'`
    # follow_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$11} END {print sum}'`
    # hash_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$13} END {print sum}'`
    # check_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$15} END {print sum}'`
    # madvise_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$17} END {print sum}'`


    search_time=`cat dmesg${i}.csv | head -n -1 | awk 'BEGIN {FS = " "} ; {sum+=$4} END {print sum}'`
    add_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$6} END {print sum}'`
    replace_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$8} END {print sum}'`
    spin_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$10} END {print sum}'`
    follow_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$12} END {print sum}'`
    hash_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$14} END {print sum}'`
    check_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$16} END {print sum}'`
    madvise_time=`cat dmesg${i}.csv | awk 'BEGIN {FS = " "} ; {sum+=$18} END {print sum}'`


    #if [ ! -f "$out_file" ]; then
    #    echo "creating file ${out_file}"
    #    echo "search_time,add_time,replace_time,spin_time,follow_time,hash_time,check_time,madvise_time" > $out_file
    #fi
    #echo "$search_time,$add_time,$replace_time,$spin_time,$follow_time,$hash_time,$check_time,$madvise_time" >> $out_file
    echo "$search_time,$add_time,$replace_time,$spin_time,$follow_time,$hash_time,$check_time,$madvise_time"
    

done
# awk 'BEGIN {FS = " "} ; {sum+=$2} END {print sum}' dmesg${i}.csv
# cat test.txt | head -n -1 | awk 'BEGIN {FS = " "} ; {sum+=$4} END {print sum}'

# cat dmesg1.csv | awk 'BEGIN {FS = " "} ; {sum+=$3} END {print sum}'
# cat dmesg1.csv | awk 'BEGIN {FS = " "} ; {sum+=$$START} END {print sum}'
