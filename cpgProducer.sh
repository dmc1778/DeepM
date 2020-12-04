#!/bin/bash

coreutilsDir="/home/nimashiri/vsprojects/DeepM/potential_methods/coreutils/methods"
findutilsDir="/home/nimashiri/vsprojects/DeepM/potential_methods/findutils/methods"
linuxDir="/home/nimashiri/vsprojects/DeepM/potential_methods/linux/methods"
makeDir="/home/nimashiri/vsprojects/DeepM/potential_methods/make/methods"
postgresDir="/home/nimashiri/vsprojects/DeepM/potential_methods/postgres/methods"
xorgDir="/home/nimashiri/vsprojects/DeepM/potential_methods/xorg/methods"

coreutilsOut="/home/nimashiri/vsprojects/DeepM/cpg_methods/coreutils"
findutilsOut="/home/nimashiri/vsprojects/DeepM/cpg_methods/findutils"
linuxOut="/home/nimashiri/vsprojects/DeepM/cpg_methods/linux"
makeOut="/home/nimashiri/vsprojects/DeepM/cpg_methods/make"
postgresOut="/home/nimashiri/vsprojects/DeepM/cpg_methods/postgres"
xorgOut="/home/nimashiri/vsprojects/DeepM/cpg_methods/xorg"

declare -a dirList=([0]=$coreutilsDir [1]=$findutilsDir [2]=$linuxDir [3]=$makeDir [4]=$postgresDir [5]=$xorgDir)
#declare -a dirList=([0]=$coreutilsDir [1]=$findutilsDir [2]=$grepDir [3]=$linuxDir [4]=$makeDir [5]=$postgresDir [6]=$xorgDir)

for i in "${dirList[@]}"
do	
    if [ $i = "/home/nimashiri/vsprojects/DeepM/potential_methods/coreutils/methods" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut
        for file in "parsed/tmp"/*
        do
            cp -r $file $coreutilsOut;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/potential_methods/findutils/methods" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut
        for file in "parsed/tmp"/*
        do
            cp -r $file $findutilsOut;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/potential_methods/linux/methods" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut
        for file in "parsed/tmp"/*
        do
            cp -r $file $linuxOut;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/potential_methods/make/methods" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut
        for file in "parsed/tmp"/*
        do
            cp -r $file $makeOut;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/potential_methods/postgres/methods" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut
        for file in "parsed/tmp"/*
        do
            cp -r $file $postgresOut;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = "/home/nimashiri/vsprojects/DeepM/potential_methods/postgres/xorg" ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut
        for file in "parsed/tmp"/*
        do
            cp -r $file $xorgOut;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
done
