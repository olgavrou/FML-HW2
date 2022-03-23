#!/bin/bash

k=5
C=$(bc -l <<< "3 ^($k)")
d=3

# clean up existing files
rm -f abalone.data.libsvm.train.scale_partition_*
rm -f fixed_d_C_*

# create the last partition which contains all of the train data
cp abalone.data.libsvm.train.scale abalone.data.libsvm.train.scale_partition_10

# split the train set into sets of increasing size
python3 C_5_manual_dataset.py

# for each partition get the train and test error

for i in $(seq 1 10); do
	# get the cross validation error
	CV_OUTPUT=$(./libsvm/svm-train -t 1 -d $d -c $C -v 5 abalone.data.libsvm.train.scale_partition_"$i" | tail -1)

	# train without cross validation to get the model
	TRAIN_OUTPUT=$(./libsvm/svm-train -t 1 -d $d -c $C abalone.data.libsvm.train.scale_partition_"$i" | tail -2 | head -1)

	# predict on test set to get the test error
	PRED_OUTPUT=$(./libsvm/svm-predict abalone.data.libsvm.test.scale abalone.data.libsvm.train.scale_partition_"$i".model out | tail -1)

	# get accuracy and use it to calc error
	CV_ACC=$(echo $CV_OUTPUT | cut -d"=" -f2 | cut -d"%" -f 1)		
	PRED_ACC=$(echo $PRED_OUTPUT | cut -d"=" -f2 | cut -d"%" -f 1)		
	CV_ERR=$( bc -l <<< "100 - $CV_ACC")
	PRED_ERR=$( bc -l <<< "100 - $PRED_ACC")

	# spit out to a file for plotting
	echo "$CV_ERR" >> fixed_d_C_cv_errors.dat
	echo "$PRED_ERR" >> fixed_d_C_test_errors.dat
done
