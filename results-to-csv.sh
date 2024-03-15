#!/bin/bash

echo "pods;cpus;s"
for f in results-*.txt; do
	cpus=$(sed -e 's/.*-\([0-9]*\)-cpus.*/\1/g' <<< "$f")
	pods=$(sed -e 's/.*-\([0-9]*\)-pods.*/\1/g' <<< "$f")
	cat $f | while read line; do echo "$pods;$cpus;$line"; done
done
