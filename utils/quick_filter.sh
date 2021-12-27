#!/bin/bash

awk '{print $9}' $1 | cut -d'-' -f1 | sort | uniq -c | sort -nr | awk '$1>=6 && $1<8' | wc -l
