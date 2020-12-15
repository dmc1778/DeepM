#!/bin/bash

coreutilsDir1="/home/nimashiri/vsprojects/DeepM/potential_methods/coreutils/coreutils-8.30_function/methods"
coreutilsDir2="/home/nimashiri/vsprojects/DeepM/potential_methods/coreutils/coreutils-8.31_functions/methods"
coreutilsDir3="/home/nimashiri/vsprojects/DeepM/potential_methods/coreutils/coreutils-8.32_functions/methods"
coreutilsDir4="/home/nimashiri/vsprojects/DeepM/potential_methods/coreutils/coreutils-master/methods"

findutilsDir1="/home/nimashiri/vsprojects/DeepM/potential_methods/findutils/findutils-4.1.20_functions/methods"
findutilsDir2="/home/nimashiri/vsprojects/DeepM/potential_methods/findutils/findutils-4.2.18_functions/methods"
findutilsDir3="/home/nimashiri/vsprojects/DeepM/potential_methods/findutils/findutils-4.2.23_functions/methods"
findutilsDir4="/home/nimashiri/vsprojects/DeepM/potential_methods/findutils/findutils-4.7.0_functions/methods"

linuxDir1="/home/nimashiri/vsprojects/DeepM/potential_methods/linux/linux-5.8_functions/methods"
linuxDir2="/home/nimashiri/vsprojects/DeepM/potential_methods/linux/linux-5.9_functions/methods"
linuxDir3="/home/nimashiri/vsprojects/DeepM/potential_methods/linux/linux-5.10_functions/methods"


makeDir1="/home/nimashiri/vsprojects/DeepM/potential_methods/make/make-4.2_functions/methods"
makeDir2="/home/nimashiri/vsprojects/DeepM/potential_methods/make/make-4.2.93_functions/methods"
makeDir3="/home/nimashiri/vsprojects/DeepM/potential_methods/make/make-4.3_functions/methods"
makeDir4="/home/nimashiri/vsprojects/DeepM/potential_methods/make/make-master_functions/methods"

postgresDir1="/home/nimashiri/vsprojects/DeepM/potential_methods/postgres/postgres-master_functions/methods"
postgresDir2="/home/nimashiri/vsprojects/DeepM/potential_methods/postgres/postgres-REL_11_10_functions/methods"
postgresDir3="/home/nimashiri/vsprojects/DeepM/potential_methods/postgres/postgres-REL_13_1_functions/methods"

xenDir1="/home/nimashiri/vsprojects/DeepM/potential_methods/xen/xen-RELEASE-4.12.4_functions/methods"
xenDir2="/home/nimashiri/vsprojects/DeepM/potential_methods/xen/xen-RELEASE-4.13.2_functions/methods"
xenDir3="/home/nimashiri/vsprojects/DeepM/potential_methods/xen/xen-RELEASE-4.14.0_functions/methods"

xorgDir1="/home/nimashiri/vsprojects/DeepM/potential_methods/xorg/xorg-xserver-master_functions/methods"
xorgDir2="/home/nimashiri/vsprojects/DeepM/potential_methods/xorg/xorg-xserver-xorg-server-1.19.7_functions/methods"
xorgDir3="/home/nimashiri/vsprojects/DeepM/potential_methods/xorg/xorg-xserver-xorg-server-1.20.9_functions/methods"
xorgDir4="/home/nimashiri/vsprojects/DeepM/potential_methods/xorg/xorg-xserver-xorg-server-1.20.10_functions/methods"

#output dirs

coreutilsOut1="/home/nimashiri/vsprojects/DeepM/cpg_methods/coreutils/coreutils-8.30_functions"
coreutilsOut2="/home/nimashiri/vsprojects/DeepM/cpg_methods/coreutils/coreutils-8.31_functions"
coreutilsOut3="/home/nimashiri/vsprojects/DeepM/cpg_methods/coreutils/coreutils-8.32_functions"
coreutilsOut4="/home/nimashiri/vsprojects/DeepM/cpg_methods/coreutils/coreutils-master"

findutilsOut1="/home/nimashiri/vsprojects/DeepM/cpg_methods/findutils/findutils-4.1.20_functions"
findutilsOut2="/home/nimashiri/vsprojects/DeepM/cpg_methods/findutils/findutils-4.2.18_functions"
findutilsOut3="/home/nimashiri/vsprojects/DeepM/cpg_methods/findutils/findutils-4.2.23_functions"
findutilsOut4="/home/nimashiri/vsprojects/DeepM/cpg_methods/findutils/findutils-4.7.0_functions"

linuxOut1="/home/nimashiri/vsprojects/DeepM/cpg_methods/linux/linux-5.8_functions"
linuxOut2="/home/nimashiri/vsprojects/DeepM/cpg_methods/linux/linux-5.9_functions"
linuxOut3="/home/nimashiri/vsprojects/DeepM/cpg_methods/linux/linux-5.10_functions"

makeOut1="/home/nimashiri/vsprojects/DeepM/cpg_methods/make/make-4.2_functions"
makeOut2="/home/nimashiri/vsprojects/DeepM/cpg_methods/make/make-4.2.93_functions"
makeOut3="/home/nimashiri/vsprojects/DeepM/cpg_methods/make/make-4.3_functions"
makeOut4="/home/nimashiri/vsprojects/DeepM/cpg_methods/make/make-master_functions"

postgresOut1="/home/nimashiri/vsprojects/DeepM/cpg_methods/postgres/postgres-master_functions"
postgresOut2="/home/nimashiri/vsprojects/DeepM/cpg_methods/postgres/postgres-REL_11_10_functions"
postgresOut3="/home/nimashiri/vsprojects/DeepM/cpg_methods/postgres/postgres-REL_13_1_functions"

xenOut1="/home/nimashiri/vsprojects/DeepM/cpg_methods/xen/xen-RELEASE-4.12.4_functions"
xenOut2="/home/nimashiri/vsprojects/DeepM/cpg_methods/xen/xen-RELEASE-4.13.2_functions"
xenOut3="/home/nimashiri/vsprojects/DeepM/cpg_methods/xen/xen-RELEASE-4.14.0_functions"

xorgOut1="/home/nimashiri/vsprojects/DeepM/cpg_methods/xorg/xorg-xserver-master_functions"
xorgOut2="/home/nimashiri/vsprojects/DeepM/cpg_methods/xorg/xorg-xserver-xorg-server-1.19.7_functions"
xorgOut3="/home/nimashiri/vsprojects/DeepM/cpg_methods/xorg/xorg-xserver-xorg-server-1.20.9_functions"
xorgOut4="/home/nimashiri/vsprojects/DeepM/cpg_methods/xorg/xorg-xserver-xorg-server-1.20.10_functions"
declare -a dirList=([0]=$coreutilsDir1 [1]=$coreutilsDir2 [2]=$coreutilsDir3 [3]=$coreutilsDir4 [4]=$findutilsDir1 [5]=$findutilsDir2 [6]]=$findutilsDir3 [7]=$findutilsDir4 [8]=$linuxDir1 [9]=$linuxDir2 [10]=$linuxDir3 [11]=$makeDir1 [12]=$makeDir2 [13]=$makeDir3 [14]=$makeDir4 [15]=$postgresDir1 [16]=$postgresDir2 [17]=$postgresDir3 [18]=$xengDir1 [19]=$xenDir2 [20]=$xenDir3 [21]=$xorgDir1 [22]=$xorgDir2 [23]=$xorgDir3 [24]=$xorgDir4)
#declare -a dirList=([0]=$coreutilsDir [1]=$findutilsDir [2]=$grepDir [3]=$linuxDir [4]=$makeDir [5]=$postgresDir [6]=$xorgDir)

for i in "${dirList[@]}"
do	
    if [ $i = $coreutilsDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut1
        for file in "parsed/tmp"/*
        do
            cp -r $file $coreutilsOut1;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $coreutilsDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut2
        for file in "parsed/tmp"/*
        do
            cp -r $file $coreutilsOut2;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $coreutilsDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut3
        for file in "parsed/tmp"/*
        do
            cp -r $file $coreutilsOut3;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $coreutilsDir4 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $coreutilsOut4
        for file in "parsed/tmp"/*
        do
            cp -r $file $coreutilsOut4;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $findutilsDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $findutilsOut1
        for file in "parsed/tmp"/*
        do
            cp -r $file $findutilsOut1;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $findutilsDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $findutilsOut2
        for file in "parsed/tmp"/*
        do
            cp -r $file $findutilsOut2;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $findutilsDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $findutilsOut3
        for file in "parsed/tmp"/*
        do
            cp -r $file $findutilsOut3;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $findutilsDir4 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $findutilsOut4
        for file in "parsed/tmp"/*
        do
            cp -r $file $findutilsOut4;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $linuxDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $linuxOut1
        for file in "parsed/tmp"/*
        do
            cp -r $file $linuxOut1;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $linuxDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $linuxOut2
        for file in "parsed/tmp"/*
        do
            cp -r $file $linuxOut2;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $linuxDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $linuxOut3
        for file in "parsed/tmp"/*
        do
            cp -r $file $linuxOut3;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $makeDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $makeOut1
        for file in "parsed/tmp"/*
        do
            cp -r $file $makeOut1;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $makeDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $makeOut2
        for file in "parsed/tmp"/*
        do
            cp -r $file $makeOut2;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $makeDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $makeOut3
        for file in "parsed/tmp"/*
        do
            cp -r $file $makeOut3;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $makeDir4 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $makeOut4
        for file in "parsed/tmp"/*
        do
            cp -r $file $makeOut4;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $postgresDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $postgresOut1
        for file in "parsed/tmp"/*
        do
            cp -r $file $postgresOut1;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $postgresDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $postgresOut2
        for file in "parsed/tmp"/*
        do
            cp -r $file $postgresOut2;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $postgresDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $postgresOut3
        for file in "parsed/tmp"/*
        do
            cp -r $file $postgresOut3;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
    if [ $i = $xenDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $xenOut1
        for file in "parsed/tmp"/*
        do
            cp -r $file $xenOut1;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $xenDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $xenOut2
        for file in "parsed/tmp"/*
        do
            cp -r $file $xenOut2;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $xenDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $xenOut3
        for file in "parsed/tmp"/*
        do
            cp -r $file $xenOut3;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $xorgDir1 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $xorgOut1
        for file in "parsed/tmp"/*
        do
            cp -r $file $xorgOut1;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $xorgDir2 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $xorgOut2
        for file in "parsed/tmp"/*
        do
            cp -r $file $xorgOut2;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $xorgDir3 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $xorgOut3
        for file in "parsed/tmp"/*
        do
            cp -r $file $xorgOut3;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
     if [ $i = $xorgDir4 ]
    then
        for file in "$i"/*
        do
            method_name=$(basename $file)
            # echo $method_name
            mkdir -p 'tmp';
            cp $i'/'$method_name 'tmp/'$method_name;	
        done
        ./joern/joern-parse tmp/;
        
        mkdir -p $xorgOut4
        for file in "parsed/tmp"/*
        do
            cp -r $file $xorgOut4;
        done 	    	
    	rm -rf parsed;
    	rm -rf tmp
    fi
done
