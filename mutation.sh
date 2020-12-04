#!/bin/bash

coreutilsDir="/home/nimashiri/vsprojects/DeepM/sliced_methods/coreutils"
findutilsDir="/home/nimashiri/vsprojects/DeepM/sliced_methods/findutils"
linuxDir="/home/nimashiri/vsprojects/DeepM/sliced_methods/linux"
makeDir="/home/nimashiri/vsprojects/DeepM/sliced_methods/make"
postgresDir="/home/nimashiri/vsprojects/DeepM/sliced_methods/postgres"
xorgDir="/home/nimashiri/vsprojects/DeepM/sliced_methods/xorg"

coreutilsOut="/home/nimashiri/vsprojects/DeepM/mutated_methods/coreutils/"
findutilsOut="/home/nimashiri/vsprojects/DeepM/mutated_methods/findutils/"
linuxOut="/home/nimashiri/vsprojects/DeepM/mutated_methods/linux/"
makeOut="/home/nimashiri/vsprojects/DeepM/mutated_methods/make/"
postgresOut="/home/nimashiri/vsprojects/DeepM/mutated_methods/postgres/"
xorgOut="/home/nimashiri/vsprojects/DeepM/mutated_methods/xorg/"

declare -a dirList=([0]=$coreutilsDir [1]=$findutilsDir [2]=$grepDir [3]=$linuxDir [4]=$makeDir [5]=$postgresDir [6]=$xorgDir)

for i in "${dirList[@]}"
do
    if [ $i = "/home/nimashiri/vsprojects/DeepM/sliced_methods/coreutils" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $coreutilsOut
            echo $method_name
            txl -o "$coreutilsOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/sliced_methods/findutils" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $findutilsOut
            echo $method_name
            txl -o "$findutilsOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/sliced_methods/linux" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $linuxOut
            echo $method_name
            txl -o "$linuxOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/sliced_methods/make" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $makeOut
            echo $method_name
            txl -o "$makeOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/sliced_methods/postgres" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $postgresOut
            echo $method_name
            txl -o "$postgresOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/sliced_methods/xorg" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xorgOut
            echo $method_name
            txl -o "$xorgOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
done


#txl -o mutatedDemo.c ./c/demo.c ./Txl/CtoCprime.Txl
