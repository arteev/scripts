#!/bin/bash
# Sound sink switcher
# Version 1.0 / August 10,2019

current=`pacmd stat | grep "Default sink name" | cut -d':' -f 2 | sed -e 's/^[ ]*//'`
sinks=`pacmd list-sinks | grep "name:" | cut -d':' -f 2`
arr=()
current_index=-1
index=0
printf "current: %s\n" $current
for item in ${sinks} 
do
    name=${item:1:-1}
    arr+=($name)
    if [[ "${name}" == "${current}" ]]; then
        current_index=$index
    fi
    index=$(($index+1))
done

arr_len=${#arr[@]}
next=$(($current_index+1))
if [ $next -ge $arr_len ]; then 
    next=0
fi

next_name=${arr[$next]}
printf "switch to: %s\n" $next_name
pacmd set-default-sink $next_name        
pacmd move-sink-input 0 $next_name