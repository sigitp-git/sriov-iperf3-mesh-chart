#!/bin/bash

PROFILE="-b 20G -P 32 -t 0"

echo "Adding CPU load - using ports 5203-5212"

PODS=($(kubectl get pods --no-headers | grep -E "(mesh-pod|lb-bgp-pod|mg-pod)" | awk '{print $1}'))
echo "Pods: ${#PODS[@]}"

# Start additional servers on new ports
echo "Starting additional servers..."
for p in "${PODS[@]}"; do
    kubectl exec $p -- sh -c "iperf3 -s -p 5203 -D; iperf3 -s -p 5204 -D; iperf3 -s -p 5205 -D; iperf3 -s -p 5206 -D; iperf3 -s -p 5207 -D; iperf3 -s -p 5208 -D; iperf3 -s -p 5209 -D; iperf3 -s -p 5210 -D; iperf3 -s -p 5211 -D; iperf3 -s -p 5212 -D" &
done
wait
sleep 5

# Build target list
TARGET_LIST=""
for p in "${PODS[@]}"; do
    ip=$(kubectl get pod $p -o jsonpath='{.status.podIP}')
    net1=$(kubectl exec $p -- ip addr show net1 2>/dev/null | awk '/inet /{print $2}' | cut -d/ -f1)
    TARGET_LIST+="$p:$ip:$net1 "
done

# Add more mesh traffic on new ports
echo "Adding traffic..."
for src in "${PODS[@]}"; do
    kubectl exec $src -- sh -c "
        for target in $TARGET_LIST; do
            pod=\${target%%:*}
            [ \"\$pod\" = \"$src\" ] && continue
            temp=\${target#*:}
            ip=\${temp%%:*}
            net1=\${temp#*:}
            
            nohup iperf3 -c \$ip -p 5203 $PROFILE >/tmp/v2_\$pod.log 2>&1 &
            nohup iperf3 -c \$ip -p 5204 $PROFILE >/tmp/v3_\$pod.log 2>&1 &
            nohup iperf3 -c \$ip -p 5205 $PROFILE >/tmp/v4_\$pod.log 2>&1 &
            nohup iperf3 -c \$ip -p 5206 $PROFILE >/tmp/v5_\$pod.log 2>&1 &
            nohup iperf3 -c \$ip -p 5207 $PROFILE >/tmp/v6_\$pod.log 2>&1 &
            [ "\$net1" != "" ] && nohup iperf3 -c \$net1 -p 5208 $PROFILE >/tmp/s2_\$pod.log 2>&1 &
            [ "\$net1" != "" ] && nohup iperf3 -c \$net1 -p 5209 $PROFILE >/tmp/s3_\$pod.log 2>&1 &
            [ "\$net1" != "" ] && nohup iperf3 -c \$net1 -p 5210 $PROFILE >/tmp/s4_\$pod.log 2>&1 &
            [ "\$net1" != "" ] && nohup iperf3 -c \$net1 -p 5211 $PROFILE >/tmp/s5_\$pod.log 2>&1 &
            [ "\$net1" != "" ] && nohup iperf3 -c \$net1 -p 5212 $PROFILE >/tmp/s6_\$pod.log 2>&1 &
        done
    " &
    echo "$src"
done

echo "Additional load started - 10x more connections per pod"
