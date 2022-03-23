#!/bin/bash -x

# bring the data into a format that libsvm can understand 
awk -F, 'BEGIN { ORS=","};{print $NF; for (i=1; i<NF; i++){print i ":" $i};print "\n"}' abalone.data | sed 's/^,//g' | sed 's/,$//g' | sed 's/,/ /g' | sed 's/1:M/1:1/g' | sed 's/1:F/1:2/g' | sed 's/1:I/1:3/g' > abalone.data.libsvm


# make labels 0-9 => -1 and 10-29 => +1
sed 's/^[0-9] /-1 /g' abalone.data.libsvm > temp
mv temp abalone.data.libsvm
sed 's/^[0-2][0-9] /+1 /g' abalone.data.libsvm > temp
mv temp abalone.data.libsvm

# C.2 split to train and test sets
split -l 3133 abalone.data.libsvm
mv xaa abalone.data.libsvm.train
mv xab abalone.data.libsvm.test

# C.2 scale the train set, store the range and use it to scale the test set
./libsvm/svm-scale -s range abalone.data.libsvm.train > abalone.data.libsvm.train.scale
./libsvm/svm-scale -r range abalone.data.libsvm.test > abalone.data.libsvm.test.scale

# C.3 split the dataset for manual cross validation
python3 C_3_cv_manual_dataset.py
