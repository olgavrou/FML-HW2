#!/bin/bash

rm manual_test_err_*

for d in $(seq 1 5); do
	for c in $(seq -10 10); do
		for inner_d in $(seq 1 5); do
			echo "$d - $c"
			ABC=$(bc -l <<< "3 ^($c)")
			OUTPUT=$(./libsvm/svm-train -t 1 -d $d -c $ABC abalone.data.libsvm.train.scale_"$inner_d"_rest | tail -1)
			OUTPUT=$(./libsvm/svm-predict abalone.data.libsvm.train.scale_"$inner_d" abalone.data.libsvm.train.scale_"$inner_d"_rest.model out | tail -1)
			ACC=$(echo $OUTPUT | cut -d"=" -f2 | cut -d"%" -f 1)		
			ERR=$( bc -l <<< "100 - $ACC")
			echo -n "$ERR," >> manual_test_err_"$d".dat
		done
		echo "" >> manual_test_err_"$d".dat
	done
done
