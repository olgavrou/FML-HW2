#!/bin/bash -x

k=5
C=$(bc -l <<< "3 ^($k)")

rm fixed_C_*

for d in $(seq 1 5); do
	echo "$d - $k"

	# clean up previous model
	rm -f abalone.data.libsvm.train.scale.model

	# get the cross validation error
	CV_OUTPUT=$(./libsvm/svm-train -t 1 -d $d -c $C -v 5 abalone.data.libsvm.train.scale | tail -1)

	# train without cross validation to get the model and support vector #
	TRAIN_OUTPUT=$(./libsvm/svm-train -t 1 -d $d -c $C abalone.data.libsvm.train.scale | tail -2 | head -1)

	# predict on test set to get the test error
	PRED_OUTPUT=$(./libsvm/svm-predict abalone.data.libsvm.test.scale abalone.data.libsvm.train.scale.model out | tail -1)

	# get accuracy and use it to calc error
	CV_ACC=$(echo $CV_OUTPUT | cut -d"=" -f2 | cut -d"%" -f 1)		
	PRED_ACC=$(echo $PRED_OUTPUT | cut -d"=" -f2 | cut -d"%" -f 1)		
	CV_ERR=$( bc -l <<< "100 - $CV_ACC")
	PRED_ERR=$( bc -l <<< "100 - $PRED_ACC")

	# get number of support vectors and support vectors on margin hyperplane
	SVMs=$(echo $TRAIN_OUTPUT | cut -d"=" -f 2 | cut -d"," -f 1)
	MSVMs=$(echo $TRAIN_OUTPUT | cut -d"=" -f 3)
	
	# spit out to a file for plotting
	echo "$CV_ERR" >> fixed_C_cv_errors.dat
	echo "$PRED_ERR" >> fixed_C_test_errors.dat
	echo "$SVMs" >> fixed_C_svms.dat
	echo "$MSVMs" >> fixed_C_m_svms.dat
done

