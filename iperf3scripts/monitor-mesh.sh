#!/bin/bash

# Monitor iperf3 processes across all pods (parallel execution)
PODS=($(kubectl get pods --no-headers | grep -E "(mesh-pod|lb-bgp-pod|mg-pod)" | awk '{print $1}'))

echo "Checking all ${#PODS[@]} pods..."
echo ""

for pod in "${PODS[@]}"; do
    (
        count=$(kubectl exec $pod -- ps aux 2>/dev/null | grep iperf3 | grep -v defunct | wc -l)
        echo "$pod: $count"
    ) &
done

wait
