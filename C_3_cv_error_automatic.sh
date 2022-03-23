#!/bin/bash

rm errors_d_*

for d in $(seq 1 5); do
	for c in $(seq -20 20); do
		echo "$d - $c"
		ABC=$(bc -l <<< "3 ^($c)")
		OUTPUT=$(./libsvm/svm-train -v 5 -t 1 -d $d -c $ABC abalone.data.libsvm.train.scale | tail -1)
		ACC=$(echo $OUTPUT | cut -d"=" -f2 | cut -d"%" -f 1)		
		ERR=$( bc -l <<< "100 - $ACC")
		echo $ERR >> errors_d_"$d".dat
	done
done
