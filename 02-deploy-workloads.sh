#!/bin/bash

pods=${pods:-10}
workload=${workload:-"workload-local.yaml"}
workload_basename=${workload%.*}

echo "creating ${workload_basename}-pod*.yaml files, pods=$pods"

rm -f "${workload_basename}"-pod*.yaml

for n in $( seq 0 $((pods - 1)) ); do 
	sed -e "s|name: \(.*\)|name: \1$n|g" < "${workload}" > "${workload_basename}-pod$n.yaml"
done

for yaml in "${workload_basename}"-pod*.yaml; do
	kubectl create -f "$yaml"
done
