#!/bin/bash

PROFILE="-b 20G -P 32 -t 0"

echo "Starting mesh - high CPU utilization mode"

# Get all pods
PODS=($(kubectl get pods --no-headers | grep -E "(mesh-pod|lb-bgp-pod|mg-pod)" | awk '{print $1}'))
echo "Pods: ${#PODS[@]}"

# Start servers
echo "Starting servers..."
for p in "${PODS[@]}"; do
    kubectl exec $p -- sh -c "pkill -9 iperf3; iperf3 -s -p 5201 -D; iperf3 -s -p 5202 -D" &
done
wait
sleep 10

# Create target list file
echo "Building target list..."
TARGET_LIST=""
for p in "${PODS[@]}"; do
    ip=$(kubectl get pod $p -o jsonpath='{.status.podIP}')
    net1=$(kubectl exec $p -- ip addr show net1 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1)
    TARGET_LIST+="$p:$ip:$net1 "
done

# Start mesh - ONE kubectl exec per pod
echo "Starting mesh traffic..."
for src in "${PODS[@]}"; do
    kubectl exec $src -- sh -c "
        for target in $TARGET_LIST; do
            pod=\${target%%:*}
            [ \"\$pod\" = \"$src\" ] && continue
            temp=\${target#*:}
            ip=\${temp%%:*}
            net1=\${temp#*:}
            
            nohup iperf3 -c \$ip -p 5201 $PROFILE >/tmp/v_\$pod.log 2>&1 &
            [ \"\$net1\" != \"\" ] && nohup iperf3 -c \$net1 -p 5202 $PROFILE >/tmp/s_\$pod.log 2>&1 &
        done
    " &
    echo "$src"
done

echo "Mesh started"
