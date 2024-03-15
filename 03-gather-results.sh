#!/bin/bash

results=${results:-"results.txt"}

echo "gathering execution times to results=$results"

set -e

rm -f "${results}"

for pod in $(kubectl get pods -o name); do
	kubectl exec -i $pod -- cat /tmp/benchmark.log | awk '{print $2}' >> "${results}"
done

cat "${results}"
