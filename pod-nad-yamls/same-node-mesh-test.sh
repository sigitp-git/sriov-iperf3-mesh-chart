#!/bin/bash

PODS=("mesh-pod-1" "mesh-pod-2" "mesh-pod-3")
IPS=("169.30.1.10" "169.30.1.20" "169.30.1.30")

echo "=== Same-Node SR-IOV Full Mesh Test ==="

# Start iperf3 servers
for i in "${!PODS[@]}"; do
    pod=${PODS[$i]}
    ip=${IPS[$i]}
    port=$((5201 + i))
    
    echo "Starting server: $pod ($ip:$port)"
    kubectl exec $pod -- bash -c "pkill iperf3; iperf3 -s -p $port -D" > /dev/null 2>&1
done

sleep 2

# Run mesh tests
echo -e "\n=== Mesh Results ==="
for i in "${!PODS[@]}"; do
    client=${PODS[$i]}
    
    for j in "${!PODS[@]}"; do
        if [ $i -ne $j ]; then
            server=${PODS[$j]}
            server_ip=${IPS[$j]}
            port=$((5201 + j))
            
            echo -n "$client -> $server: "
            
            result=$(kubectl exec $client -- timeout 8 iperf3 -c $server_ip -p $port -t 3 --json 2>/dev/null)
            
            if [ $? -eq 0 ]; then
                throughput=$(echo "$result" | jq -r '.end.sum_received.bits_per_second // 0' 2>/dev/null)
                if [ "$throughput" != "0" ] && [ "$throughput" != "null" ]; then
                    gbps=$(echo "scale=2; $throughput / 1000000000" | bc -l)
                    echo "✓ ${gbps} Gbps"
                else
                    echo "⚠ Connected"
                fi
            else
                echo "✗ Failed"
            fi
        fi
    done
done

# Cleanup
for pod in "${PODS[@]}"; do
    kubectl exec $pod -- pkill iperf3 > /dev/null 2>&1
done

echo -e "\n=== Test Complete ==="
