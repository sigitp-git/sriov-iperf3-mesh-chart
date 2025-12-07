#!/bin/bash

PODS=("mesh-pod-2" "mesh-pod-3" "mesh-pod-4")
IPS=("169.30.1.20" "169.30.1.30" "169.30.1.40")

echo "=== Starting 24/7 SR-IOV Mesh Test ==="

# Start iperf3 servers on all pods
for i in "${!PODS[@]}"; do
    pod=${PODS[$i]}
    ip=${IPS[$i]}
    port=$((5201 + i))
    
    echo "Starting permanent server: $pod ($ip:$port)"
    kubectl exec $pod -- bash -c "pkill iperf3; nohup iperf3 -s -p $port > /dev/null 2>&1 &"
done

sleep 2

# Start continuous mesh testing
while true; do
    echo "$(date): Running mesh test cycle..."
    
    for i in "${!PODS[@]}"; do
        client=${PODS[$i]}
        
        for j in "${!PODS[@]}"; do
            if [ $i -ne $j ]; then
                server=${PODS[$j]}
                server_ip=${IPS[$j]}
                port=$((5201 + j))
                
                # Run test in background
                kubectl exec $client -- bash -c "timeout 8 iperf3 -c $server_ip -p $port -t 3 --json > /tmp/mesh_${client}_to_${server}.json 2>/dev/null" &
            fi
        done
    done
    
    # Wait for all tests to complete
    wait
    
    # Log results
    echo "$(date): Mesh test cycle completed"
    
    # Sleep between cycles (adjust as needed)
    sleep 30
done
