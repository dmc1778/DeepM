#!/bin/bash

coreutilsDir1="/home/nimashiri/make-4.3/lib"
#coreutilsDir2="/home/nimashiri/findutils-4.7.0/gl/lib"

coreutilsOut1="/home/nimashiri/make-4.3/lib/"
#coreutilsOut2="/home/nimashiri/findutils-4.7.0/gl/lib/"

declare -a dirList=([0]=$coreutilsDir1 [1]=$coreutilsDir2)

for i in "${dirList[@]}"
do	
    if [ $i = $coreutilsDir1 ]
    then
        for file in "$i"/*
        do
        if [[ $file =~ \.c$ ]];
        then
		method_name=$(basename $file)
	        # mkdir -p $coreutilsOut1
		# echo $method_name
		txl -o "$coreutilsOut1$method_name" $file ./Txl/CtoCprime.Txl
	fi
    done
    fi
    if [ $i = $coreutilsDir2 ]
    then
        for file in "$i"/*
        do
        if [[ $file =~ \.c$ ]];
        then
		method_name=$(basename $file)
	        # mkdir -p $coreutilsOut2
		# echo $method_name
		txl -o "$coreutilsOut2$method_name" $file ./Txl/CtoCprime.Txl
	fi
    done
    fi
done
