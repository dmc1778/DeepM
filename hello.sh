#!/bin/sh

coreutilsDir="./potential_methods/coreutils/method/3"
findutilsDir="./potential_methods/findutils/method/3"
grepDir="./potential_methods/grep/method/3"
linuxDir="./potential_methods/linux/method/3"
makeDir="./potential_methods/make/method/3"
postgresDir="./potential_methods/postgres/method/3"
xorgDir="./potential_methods/xorg/method/3"

coreutilsOut="./mutated_methods/coreutils/3/"
findutilsOut="./mutated_methods/findutils/3/"
grepOut="./mutated_methods/grep/3/"
linuxOut="./mutated_methods/linux/3/"
makeOut="./mutated_methods/make/3/"
postgresOut="./mutated_methods/postgres/3/"
xorgOut="./mutated_methods/xorg/3/"

declare -a dirList=([0]=$coreutilsDir [1]=$findutilsDir [2]=$grepDir [3]=$linuxDir [4]=$makeDir [5]=$postgresDir [6]=$xorgDir)

for i in "${dirList[@]}"
do
    if [ $i = "./potential_methods/coreutils/method/3" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            echo $method_name
            txl -o "$coreutilsOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "./potential_methods/findutils/method/3" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            echo $method_name
            txl -o "$findutilsOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "./potential_methods/grep/method/3" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            echo $method_name
            txl -o "$grepOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "./potential_methods/linux/method/3" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            echo $method_name
            txl -o "$linuxOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "./potential_methods/make/method/3" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            echo $method_name
            txl -o "$makeOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "./potential_methods/postgres/method/3" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            echo $method_name
            txl -o "$postgresOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = "./potential_methods/xorg/method/3" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            echo $method_name
            txl -o "$xorgOut$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
done


#txl -o mutatedDemo.c ./c/demo.c ./Txl/CtoCprime.Txl
