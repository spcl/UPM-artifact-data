#!/bin/bash

#in pmap -XX, $5 = inode, $9 = rss, $10 = pss, $11 = shared_clean, $12 = shared_dirty, $13 = private_clean, $14 = private_dirty, $16 = anonymous

txt=$1
out_file=$2

file_private_clean=`cat $txt | head -n -2 | tail -n +2 | awk '$13>0' | awk '$5>0'`
file_shared_clean=`cat $txt | head -n -2 | tail -n +2 | awk '$11>0' | awk '$5>0'`
file_backed=`cat $txt | head -n -2 | tail -n +2 | awk '$5>0 && $16==0'`

# size_file_rss=`cat $txt | head -n -2 | tail -n +2 | awk '$5>0 && $16==0' | awk '{print $9}' | awk '{sum+=$1}END{print sum}'`
# size_file_shared_clean=`cat $txt | head -n -2 | tail -n +2 | awk '$5>0' | awk '{print $11}' | awk '{sum+=$1}END{print sum}'`
# size_file_private_clean=`cat $txt | awk '$5>0' | awk '{print $13}' | head -n -2 | tail -n +2 | awk '{sum+=$1}END{print sum}'`
# size_file_private_dirty=`cat $txt | head -n -2 | tail -n +2 | awk '$5>0' | awk '{print $14}' | awk '{sum+=$1}END{print sum}'`

#echo "FILE-BACKED INFO:"
#echo "size_file_rss: $size_file_rss"
#echo "size_file_shared_clean: $size_file_shared_clean"
#echo "size_file_private_clean: $size_file_private_clean"
#echo "size_file_private_dirty: $size_file_private_dirty"

rss=`cat $txt | tail -n 1 | awk '{print $4}'`
pss=`cat $txt | tail -n 1 | awk '{print $5}'`
anonymous=`cat $txt | tail -n 1 | awk '{print $11}'`
shared_clean=`cat $txt | tail -n 1 | awk '{print $6}'`
private_clean=`cat $txt | tail -n 1 | awk '{print $8}'`
private_dirty=`cat $txt | tail -n 1 | awk '{print $9}'`
file_backed=$((rss-anonymous))
    
if [[ -z "$out_file" ]]; then
    echo "GENERAL INFO:"
    echo "rss: $rss"
    echo "pss: $pss"
    echo "file-backed: $file_backed"
    echo "anonymous: $anonymous"
    echo "shared_clean(already shared): $shared_clean"
else
    if [ ! -f "$out_file" ]; then
        echo "creating file ${out_file}"
        echo "file,rss,pss,shared_clean,private_clean,private_dirty,anonymous,file_backed" > $out_file
    fi
    #file_name=`echo $txt | awk -F / '{print $NF}'`
    echo "$txt,$rss,$pss,$shared_clean,$private_clean,$private_dirty,$anonymous,$file_backed" >> $out_file
fi
