#!/bin/bash

coreutilsDir1="/home/nimashiri/coreutils-8.10/src"
# coreutilsDir2="/home/nimashiri/coreutils-8.10/lib"
: '
coreutilsDir2="/home/nimashiri/vsprojects/DeepM/sliced_methods/coreutils/coreutils-8.31_functions"
coreutilsDir3="/home/nimashiri/vsprojects/DeepM/sliced_methods/coreutils/coreutils-8.32_functions"
coreutilsDir4="/home/nimashiri/vsprojects/DeepM/sliced_methods/coreutils/coreutils-master"

findutilsDir1="/home/nimashiri/vsprojects/DeepM/sliced_methods/findutils/findutils-4.1.20_functions"
findutilsDir2="/home/nimashiri/vsprojects/DeepM/sliced_methods/findutils/findutils-4.2.18_functions"
findutilsDir3="/home/nimashiri/vsprojects/DeepM/sliced_methods/findutils/findutils-4.2.23_functions"
findutilsDir4="/home/nimashiri/vsprojects/DeepM/sliced_methods/findutils/findutils-4.7.0_functions"

linuxDir1="/home/nimashiri/vsprojects/DeepM/sliced_methods/linux/linux-5.8_functions"
linuxDir2="/home/nimashiri/vsprojects/DeepM/sliced_methods/linux/linux-5.9_functions"
linuxDir3="/home/nimashiri/vsprojects/DeepM/sliced_methods/linux/linux-5.10_functions"


makeDir1="/home/nimashiri/vsprojects/DeepM/sliced_methods/make/make-4.2_functions"
makeDir2="/home/nimashiri/vsprojects/DeepM/sliced_methods/make/make-4.2.93_functions"
makeDir3="/home/nimashiri/vsprojects/DeepM/sliced_methods/make/make-4.3_functions"
makeDir4="/home/nimashiri/vsprojects/DeepM/sliced_methods/make/make-master_functions"

postgresDir1="/home/nimashiri/vsprojects/DeepM/sliced_methods/postgres/postgres-master_functions"
postgresDir2="/home/nimashiri/vsprojects/DeepM/sliced_methods/postgres/postgres-REL_11_10_functions"
postgresDir3="/home/nimashiri/vsprojects/DeepM/sliced_methods/postgres/postgres-REL_13_1_functions"

xenDir1="/home/nimashiri/vsprojects/DeepM/sliced_methods/xen/xen-RELEASE-4.12.4_functions"
xenDir2="/home/nimashiri/vsprojects/DeepM/sliced_methods/xen/xen-RELEASE-4.13.2_functions"
xenDir3="/home/nimashiri/vsprojects/DeepM/sliced_methods/xen/xen-RELEASE-4.14.0_functions"

xorgDir1="/home/nimashiri/vsprojects/DeepM/sliced_methods/xorg/xorg-xserver-master_functions"
xorgDir2="/home/nimashiri/vsprojects/DeepM/sliced_methods/xorg/xorg-xserver-xorg-server-1.19.7_functions"
xorgDir3="/home/nimashiri/vsprojects/DeepM/sliced_methods/xorg/xorg-xserver-xorg-server-1.20.9_functions"
xorgDir4="/home/nimashiri/vsprojects/DeepM/sliced_methods/xorg/xorg-xserver-xorg-server-1.20.10_functions"
'

#output dirs

coreutilsOut1="/home/nimashiri/coreutils-8.10/src/"
# coreutilsOut2="/home/nimashiri/coreutils-8.10/lib"
: '
coreutilsOut2="/home/nimashiri/vsprojects/DeepM/mutated_methods/coreutils/coreutils-8.31_functions/"
coreutilsOut3="/home/nimashiri/vsprojects/DeepM/mutated_methods/coreutils/coreutils-8.32_functions/"
coreutilsOut4="/home/nimashiri/vsprojects/DeepM/mutated_methods/coreutils/coreutils-master/"

findutilsOut1="/home/nimashiri/vsprojects/DeepM/mutated_methods/findutils/findutils-4.1.20_functions/"
findutilsOut2="/home/nimashiri/vsprojects/DeepM/mutated_methods/findutils/findutils-4.2.18_functions/"
findutilsOut3="/home/nimashiri/vsprojects/DeepM/mutated_methods/findutils/findutils-4.2.23_functions/"
findutilsOut4="/home/nimashiri/vsprojects/DeepM/mutated_methods/findutils/findutils-4.7.0_functions/"

linuxOut1="/home/nimashiri/vsprojects/DeepM/mutated_methods/linux/linux-5.8_functions/"
linuxOut2="/home/nimashiri/vsprojects/DeepM/mutated_methods/linux/linux-5.9_functions/"
linuxOut3="/home/nimashiri/vsprojects/DeepM/mutated_methods/linux/linux-5.10_functions/"

makeOut1="/home/nimashiri/vsprojects/DeepM/mutated_methods/make/make-4.2_functions/"
makeOut2="/home/nimashiri/vsprojects/DeepM/mutated_methods/make/make-4.2.93_functions/"
makeOut3="/home/nimashiri/vsprojects/DeepM/mutated_methods/make/make-4.3_functions/"
makeOut4="/home/nimashiri/vsprojects/DeepM/mutated_methods/make/make-master_functions/"

postgresOut1="/home/nimashiri/vsprojects/DeepM/mutated_methods/postgres/postgres-master_functions/"
postgresOut2="/home/nimashiri/vsprojects/DeepM/mutated_methods/postgres/postgres-REL_11_10_functions/"
postgresOut3="/home/nimashiri/vsprojects/DeepM/mutated_methods/postgres/postgres-REL_13_1_functions/"

xenOut1="/home/nimashiri/vsprojects/DeepM/mutated_methods/xen/xen-RELEASE-4.12.4_functions/"
xenOut2="/home/nimashiri/vsprojects/DeepM/mutated_methods/xen/xen-RELEASE-4.13.2_functions/"
xenOut3="/home/nimashiri/vsprojects/DeepM/mutated_methods/xen/xen-RELEASE-4.14.0_functions/"

xorgOut1="/home/nimashiri/vsprojects/DeepM/mutated_methods/xorg/xorg-xserver-master_functions/"
xorgOut2="/home/nimashiri/vsprojects/DeepM/mutated_methods/xorg/xorg-xserver-xorg-server-1.19.7_functions/"
xorgOut3="/home/nimashiri/vsprojects/DeepM/mutated_methods/xorg/xorg-xserver-xorg-server-1.20.9_functions/"
xorgOut4="/home/nimashiri/vsprojects/DeepM/mutated_methods/xorg/xorg-xserver-xorg-server-1.20.10_functions/"
'

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
	        # mkdir -p $coreutilsOut1
		# echo $method_name
		txl -o "$coreutilsOut2$method_name" $file ./Txl/CtoCprime.Txl
	fi
    done
    fi
    :'
    if [ $i = $coreutilsDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $coreutilsOut2
            echo $method_name
            txl -o "$coreutilsOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $coreutilsDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $coreutilsOut3
            echo $method_name
            txl -o "$coreutilsOut3$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $coreutilsDir4 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $coreutilsOut4
            echo $method_name
            txl -o "$coreutilsOut4$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $findutilsDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $findutilsOut1
            echo $method_name
            txl -o "$findutilsOut1$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $findutilsDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $findutilsOut2
            echo $method_name
            txl -o "$findutilsOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $findutilsDir3 ]
    then
      for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $findutilsOut3
            echo $method_name
            txl -o "$findutilsOut3$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $findutilsDir4 ]
    then
       for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $findutilsOut4
            echo $method_name
            txl -o "$findutilsOut4$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $linuxDir1 ]
    then
       for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $linuxOut1
            echo $method_name
            txl -o "$linuxOut1$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $linuxDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $linuxOut2
            echo $method_name
            txl -o "$linuxOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $linuxDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $linuxOut3
            echo $method_name
            txl -o "$linuxOut3$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $makeDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $makeOut1
            echo $method_name
            txl -o "$makeOut1$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
     if [ $i = $makeDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $makeOut2
            echo $method_name
            txl -o "$makeOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
     if [ $i = $makeDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $makeOut3
            echo $method_name
            txl -o "$makeOut3$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
     if [ $i = $makeDir4 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $makeOut4
            echo $method_name
            txl -o "$makeOut4$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $postgresDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $postgresOut1
            echo $method_name
            txl -o "$postgresOut1$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $postgresDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $postgresOut2
            echo $method_name
            txl -o "$postgresOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $postgresDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $postgresOut2
            echo $method_name
            txl -o "$postgresOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $xenDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xenOut1
            echo $method_name
            txl -o "$xenOut1$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $xenDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xenOut2
            echo $method_name
            txl -o "$xenOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $xenDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xenOut3
            echo $method_name
            txl -o "$xenOut3$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $xorgDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xorgOut1
            echo $method_name
            txl -o "$xorgOut1$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $xorgDir2 ]
    then
       for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xorgOut2
            echo $method_name
            txl -o "$xorgOut2$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $xorgDir3 ]
    then
      for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xorgOut3
            echo $method_name
            txl -o "$xorgOut3$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    if [ $i = $xorgDir4 ]
    then
      for file in "$i"/*
        do
            method_name=$(basename $file)
            mkdir -p $xorgOut4
            echo $method_name
            txl -o "$xorgOut4$method_name" $file ./Txl/CtoCprime.Txl
        done
    fi
    '
done
