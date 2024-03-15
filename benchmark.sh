#!/bin/bash

# Usage:
# spec=( "cpus=4 pods=8" "cpus=8 pods=8" ) ./benchmark.sh

if [[ -z "${specs[0]}" ]]; then
	specs=(
            "cpus=128 pods=20"
            "cpus=2 pods=20"
            "cpus=4 pods=20"
	)
fi

#./01-make-import-local-image.sh
./10-deploy-balloons.sh

for spec in "${specs[@]}"; do (
	./04-delete-workloads.sh

	echo "running benchmark spec='$spec'"

	eval "$spec"
	if [[ "$cpus" != "128" ]]; then
		# Modify balloons policy according to spec and deploy it
		sed -e "s/CPUs: .*/CPUs: $cpus/g" < default.balloonspolicy.yaml > benchmark.balloonspolicy.yaml
		kubectl delete -n kube-system balloonspolicies --all
		kubectl create -n kube-system -f benchmark.balloonspolicy.yaml
		sleep 2
	else
		# cpus=128 means there are no balloons policy at all, no cpu/mem pinning
		./11-uninstall-balloons.sh
		kubectl delete -n kube-system balloonspolicies --all
		sleep 1
	fi

	# Launch workloads
	pods=$pods ./02-deploy-workloads.sh
	sleep 10m

	# For validation: store CPU and memory pinning
	pinfile="pinning-$cpus-cpus-$pods-pods.txt"
	rm -f "${pinfile}"
	for pid in $(pidof python); do
		grep _allowed_list /proc/$pid/status >> "${pinfile}"
	done

	# Gather training times
	results="results-$cpus-cpus-$pods-pods.txt" ./03-gather-results.sh
); done
