#!/bin/bash

coreutilsDir1="/home/nimashiri/postgres-REL_13_1/src"

coreutilsOut1="/home/nimashiri/postgres-REL_13_1/src/"


declare -a dirList=([0]=$coreutilsDir1)

for i in "${dirList[@]}"
do	
    if [[ $i = $coreutilsDir1 ]]
    then
	    for entry in "$i"/*
	    do
		for file in "$entry"/*
		do
		if [[ $file =~ \.c$ ]];
		then
			method_name=$(basename $file)
			# mkdir -p $coreutilsOut1
			# echo $method_name
			txl -o "$coreutilsOut1$method_name" $file ./Txl/CtoCprime.Txl
		fi
	    done
    done
    fi
done
