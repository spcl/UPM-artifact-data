#!/bin/bash

curl_command=$1
times=$2

echo "invoking $times times:"
echo "command: $curl_command"
for ((i=1; i<=times; i++))
do
    $curl_command
done