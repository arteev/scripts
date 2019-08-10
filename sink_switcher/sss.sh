#!/bin/bash
# Sound sink switcher
# Version 1.1 / August 10,2019

current=`pacmd stat | grep "Default sink name" | cut -d':' -f 2 | sed -e 's/^[ ]*//'`
sinks=`pacmd list-sinks | grep "name:" | cut -d':' -f 2 | sed -e 's/^[ ]*//'`
desc=`pacmd list-sinks | grep "device.description" |  cut -d'=' -f 2 | sed -e 's/^[ ]*//'` 

IFS=$'\n'
descriptions=()
for s in ${desc} 
do
  descriptions+=($s)
done

 
arr=()
current_index=-1
index=0
for item in ${sinks} 
do
    name=${item:1:-1}
    arr+=($name)
    if [[ "${name}" == "${current}" ]]; then
        current_index=$index
    fi
    index=$(($index+1))
done

#printf "current: %s\n" ${descriptions[$current_index]}

next=$(($current_index+1))
if [ $next -ge ${#arr[@]} ]; then 
    next=0
fi

next_name=${arr[$next]}
echo ${descriptions[$next]}
pacmd set-default-sink $next_name        
pacmd move-sink-input 0 $next_name