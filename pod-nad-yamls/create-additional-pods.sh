#!/bin/bash

# Create additional pods to fully load both worker nodes
# Node1: 16 more VFs available, Node2: 20 more VFs available

echo "Creating additional pods to fully utilize SR-IOV resources..."

# Create 16 additional single-VF pods for node1
for i in {5..20}; do
cat > mg-pod${i}-node1.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: mg-pod${i}-node1
  annotations:
    k8s.v1.cni.cncf.io/networks: n3-1001-numa0p0-pf1
spec:
  nodeSelector:
    kubernetes.io/hostname: ip-100-77-4-181.ec2.internal
  containers:
  - name: ubuntu-netutils
    image: ubuntu:20.04
    command: ["sleep", "infinity"]
    securityContext:
      privileged: true
      capabilities:
        add: ["NET_ADMIN", "SYS_TIME"]
    resources:
      requests:
        aws-cse-lc-bundle/mlnx_sriov_netdevice: 1
      limits:
        aws-cse-lc-bundle/mlnx_sriov_netdevice: 1
EOF
done

# Create 20 additional single-VF pods for node2  
for i in {4..23}; do
cat > mg-pod${i}-node2.yaml << EOF
apiVersion: v1
kind: Pod
metadata:
  name: mg-pod${i}-node2
  annotations:
    k8s.v1.cni.cncf.io/networks: n3-1001-numa0p0-pf1
spec:
  nodeSelector:
    kubernetes.io/hostname: ip-100-77-4-183.ec2.internal
  containers:
  - name: ubuntu-netutils
    image: ubuntu:20.04
    command: ["sleep", "infinity"]
    securityContext:
      privileged: true
      capabilities:
        add: ["NET_ADMIN", "SYS_TIME"]
    resources:
      requests:
        aws-cse-lc-bundle/mlnx_sriov_netdevice: 1
      limits:
        aws-cse-lc-bundle/mlnx_sriov_netdevice: 1
EOF
done

echo "Created $(ls mg-pod*-node*.yaml | wc -l) additional pod manifests"
echo "Deploying pods..."

# Deploy all new pods
kubectl apply -f mg-pod*-node*.yaml

echo "Waiting for pods to start..."
sleep 30

echo "Checking pod status..."
kubectl get pods | grep -E "mg-pod[0-9]+-node" | tail -20
