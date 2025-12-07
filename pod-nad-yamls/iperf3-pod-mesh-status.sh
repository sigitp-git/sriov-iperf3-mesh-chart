#!/bin/bash

# Pod-based iperf3 with enhanced status reporting
PODS=($(kubectl get pods --no-headers | grep Running | grep -E "(mg-pod|lb-bgp-pod)" | awk '{print $1}' | sort))

echo "Starting pod-based iperf3 testing with ${#PODS[@]} pods..."
echo "Expected connections: $((${#PODS[@]} * (${#PODS[@]} - 1)))"

# Install iperf3 quickly
echo "Installing iperf3..."
for pod in "${PODS[@]}"; do
    kubectl exec $pod -- bash -c "which iperf3 || apt-get update -qq && apt-get install -y -qq iperf3" &
done
wait

# Get pod IPs
declare -A POD_IPS
for pod in "${PODS[@]}"; do
    POD_IPS[$pod]=$(kubectl get pod $pod -o jsonpath='{.status.podIP}')
done

# Create simple test script
cat > /tmp/simple-mesh-test.sh << 'EOF'
#!/bin/bash
POD_NAME=$(hostname)
POD_IP=$(ip route get 1.1.1.1 | awk '{print $7; exit}')

# Start server
pkill iperf3 2>/dev/null
iperf3 -s -D

# Test function
test_target() {
    local target=$1
    while true; do
        echo "$(date '+%H:%M:%S'): $POD_NAME->$target"
        timeout 20 iperf3 -c $target -t 15 -i 0 | tail -3
        sleep 30
    done
}

# Read targets and start tests
for target in $(cat /tmp/targets.txt); do
    [ "$target" != "$POD_IP" ] && test_target $target &
done

# Status loop
while true; do
    echo "$(date '+%H:%M:%S'): $POD_NAME active tests: $(jobs -r | wc -l)"
    sleep 60
done
EOF

# Deploy to pods
echo "Deploying test script..."
for pod in "${PODS[@]}"; do
    # Create target list for this pod
    targets=""
    for target_pod in "${PODS[@]}"; do
        [ "$pod" != "$target_pod" ] && targets="$targets ${POD_IPS[$target_pod]}"
    done
    echo $targets > /tmp/targets_${pod}.txt
    
    kubectl cp /tmp/simple-mesh-test.sh $pod:/tmp/simple-mesh-test.sh
    kubectl cp /tmp/targets_${pod}.txt $pod:/tmp/targets.txt
    kubectl exec $pod -- chmod +x /tmp/simple-mesh-test.sh
done

# Start testing
echo "Starting tests on all pods..."
kubectl get pods --no-headers | grep -E "(mg-pod|lb-bgp-pod)" | awk '{print $1}' | xargs -I {} kubectl exec {} -- bash -c "nohup /tmp/simple-mesh-test.sh > /tmp/test.log 2>&1 &"

echo "Pod-based testing started! Monitoring status..."
echo "To stop: kubectl get pods --no-headers | grep -E '(mg-pod|lb-bgp-pod)' | awk '{print \$1}' | xargs -I {} kubectl exec {} -- pkill -f simple-mesh-test.sh"

# Status monitoring
while true; do
    echo ""
    echo "$(date): Pod Performance Testing Status"
    echo "======================================"
    
    running=0
    total_tests=0
    
    for pod in "${PODS[@]}"; do
        if kubectl exec $pod -- pgrep -f simple-mesh-test.sh >/dev/null 2>&1; then
            ((running++))
            tests=$(kubectl exec $pod -- bash -c "jobs -r 2>/dev/null | wc -l" 2>/dev/null || echo "0")
            total_tests=$((total_tests + tests))
        fi
    done
    
    echo "Pods running: $running/${#PODS[@]}"
    echo "Active tests: $total_tests"
    echo "Expected: $((${#PODS[@]} * (${#PODS[@]} - 1)))"
    
    # Show sample output from first 3 pods
    echo ""
    echo "Sample outputs:"
    for i in {0..2}; do
        if [ $i -lt ${#PODS[@]} ]; then
            pod="${PODS[$i]}"
            echo "  $pod:"
            kubectl exec $pod -- tail -2 /tmp/test.log 2>/dev/null | head -1 || echo "    No output yet"
        fi
    done
    
    sleep 60
done
