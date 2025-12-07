# SR-IOV Pod and Network Attachment Definitions

This directory contains Kubernetes manifests for deploying SR-IOV enabled pods with Mellanox ConnectX network interfaces.

## Directory Contents

### Network Attachment Definitions (NADs)
- `nad-n3-*.yaml` - VLAN 1001/1002 network definitions for n3 interfaces
- `nad-n4-*.yaml` - VLAN 201/202/3001/3002 network definitions for n4 interfaces  
- `nad-n6-*.yaml` - VLAN 2001/2002 network definitions for n6 interfaces
- `nad-dsf-*.yaml` - VLAN 301/302 network definitions for DSF interfaces
- `nad-*-unique*.yaml` - Unique IP NADs for multi-VF pods (mg-pod4)

### Pod Manifests
- `mg-pod*.yaml` - Management pods (1-4 VFs each)
- `lb-bgp-pod*.yaml` - Load balancer BGP pods
- `mg-pod4-simple.yaml` - Simplified 4-VF pod for testing

### Configuration Files
- `sriov-dp-configmap-*.yaml` - SR-IOV device plugin configurations
- `mlnx-dpdk-*.yaml` - DPDK application pods
- `nokia-app-level-tagging.yaml` - Application tagging configuration

## Prerequisites

1. **SR-IOV Device Plugin**: Ensure SR-IOV device plugin is running
2. **SR-IOV Resources**: Verify `aws-cse-lc-bundle/mlnx_sriov_netdevice` resources are available
3. **Node Labels**: Nodes must be labeled with correct hostnames:
   - `ip-100-77-4-181.ec2.internal` (node1)
   - `ip-100-77-4-183.ec2.internal` (node2)

## Deployment Instructions

### 1. Check SR-IOV Resources
```bash
kubectl describe nodes | grep "aws-cse-lc-bundle/mlnx_sriov_netdevice"
```

### 2. Deploy Network Attachment Definitions
```bash
# Deploy standard NADs (exclude yamlov files)
for f in nad-n3-*.yaml nad-n4-*.yaml nad-n6-*.yaml nad-dsf-*.yaml; do 
  [[ ! "$f" =~ yamlov ]] && kubectl apply -f "$f"
done

# Deploy unique NADs for multi-VF pods
kubectl apply -f nad-dsf-*-unique*.yaml
```

### 3. Deploy Pods
```bash
# Deploy standard pods (exclude yamlov files and test pods)
for f in mg-pod*.yaml lb-bgp-pod*.yaml; do 
  [[ ! "$f" =~ yamlov ]] && [[ "$f" != "mg-pod-static-test.yaml" ]] && kubectl apply -f "$f"
done

# Deploy multi-VF pod
kubectl apply -f mg-pod4-simple.yaml
```

### 4. Verify Deployment
```bash
kubectl get pods -o wide | grep -E "(mg-pod|lb-bgp-pod)"
```

## Network Configuration

### IPAM Configuration
- **Type**: Static IP allocation (whereabouts disabled due to corruption issues)
- **IP Range**: 169.30.1.x/24
- **Standard pods**: 169.30.1.100/24
- **Multi-VF pods**: 169.30.1.101-104/24 (unique IPs per interface)

### VLAN Mappings
- **n3**: VLAN 1001, 1002
- **n4**: VLAN 201, 202, 3001, 3002  
- **n6**: VLAN 2001, 2002
- **dsf**: VLAN 301, 302

### SR-IOV Resource Requirements
- **mg-pod1-3**: 1 VF each
- **mg-pod4**: 4 VFs (uses unique NADs)
- **lb-bgp-pod**: 1 VF each

## Troubleshooting

### Common Issues

1. **ContainerCreating Status**
   - Check SR-IOV device plugin: `kubectl logs -n kube-system -l app=sriov-device-plugin`
   - Verify VF availability: `kubectl describe node <node-name>`

2. **Network Attachment Failures**
   - Validate NAD JSON syntax: `kubectl get nad <nad-name> -o yaml`
   - Check multus logs: `kubectl logs -n kube-system -l app=multus`

3. **IP Allocation Conflicts**
   - Use unique NADs for multi-VF pods
   - Avoid whereabouts IPAM (use static allocation)

### Useful Commands
```bash
# Check pod events
kubectl describe pod <pod-name>

# View network interfaces in pod
kubectl exec <pod-name> -- ip addr show

# Check SR-IOV network node policies
kubectl get sriovnetworknodepolicy -n sriov-network-operator
```

## Performance Testing

### SR-IOV Full Mesh Testing with Unique IP Addresses

```bash
./same-node-mesh-test.sh
```

**✅ Working SR-IOV Full Mesh Configuration:**
- **3 pods** on same physical node with **unique IP addresses**
- **5 out of 6 connections successful** (83% success rate)
- **Throughput: 35-46 Gbps** - excellent SR-IOV performance
- **All traffic uses SR-IOV interfaces** (net1) - no eth0 involvement

#### Final Configuration
- `mesh-pod-2`: 169.30.1.20/24 (enP1p5s0f1v7)
- `mesh-pod-3`: 169.30.1.30/24 (enP1p5s0f1v2)
- `mesh-pod-4`: 169.30.1.40/24 (SR-IOV VF)

#### Key Achievements
1. ✅ **Fixed unique IP addresses**: Resolved duplicate IP issue (all pods previously had 169.30.1.100)
2. ✅ **Same-node deployment**: All pods on ip-100-77-4-181.ec2.internal for SR-IOV connectivity
3. ✅ **High-performance mesh**: 35-46 Gbps throughput via SR-IOV interfaces
4. ✅ **No localhost involvement**: Pure pod-to-pod SR-IOV communication

#### Network Attachment Definitions for Unique IPs
- `n3-unique-10`: 169.30.1.10/24 (VLAN 3)
- `n3-unique-20`: 169.30.1.20/24 (VLAN 3)
- `n3-unique-30`: 169.30.1.30/24 (VLAN 3)
- `n3-unique-40`: 169.30.1.40/24 (VLAN 3)

#### Usage
```bash
# Run the working mesh test
cd /home/ubuntu/ubuntu-mlnx-dpdk/pod-nad-yamls
./same-node-mesh-test.sh

# Expected output: 35-46 Gbps throughput between pods
# mesh-pod-2 -> mesh-pod-3: ✓ 46.11 Gbps
# mesh-pod-3 -> mesh-pod-4: ✓ 45.29 Gbps
```

#### 24/7 Continuous SR-IOV Mesh Testing (2025-12-07)

**✅ Current Status: Dual-Node 24/7 Testing Active**
- **Node1 (ip-100-77-4-181)**: 3 pods with unique IPs (169.30.1.20/30/40) - 35+ Gbps
- **Node2 (ip-100-77-4-183)**: 3 pods with shared IP (169.30.1.100) - Standard performance
- **Zero localhost CPU consumption** - All testing runs within pods
- **Optimized configuration** - Controlled concurrency to prevent resource contention

#### Performance Optimization Lessons Learned

**Issue: Traffic Degradation (2025-12-07 00:00 UTC)**
- **Root Cause**: Too many concurrent iperf3 processes (24+ per node) causing resource contention
- **Symptoms**: "Server busy" errors, degraded throughput, process overload
- **Solution**: Process cleanup and optimized deployment with controlled concurrency

**Optimized Configuration:**
- **Parallel streams**: 24 streams per connection (vs 128+ that caused overload)
- **Test duration**: 20 seconds with 15-second intervals
- **Process management**: Clean server startup, controlled client concurrency
- **Resource limits**: Prevent SR-IOV interface saturation

#### Monitoring Commands
```bash
# Monitor Node1 optimized mesh
kubectl exec mesh-pod-2 -- tail -f /tmp/optimized.log

# Monitor Node2 mesh activity
kubectl exec lb-bgp-pod-node2-n3 -- tail -f /tmp/node2-mesh.log

# Check process count (should be controlled)
kubectl exec mesh-pod-2 -- ps aux | grep iperf3 | wc -l

# Stop all testing if needed
for pod in mesh-pod-2 mesh-pod-3 mesh-pod-4; do
  kubectl exec $pod -- pkill -f iperf3
done
```

#### Performance Characteristics
- **Maximum achievable**: 35-40 Gbps per SR-IOV VF connection
- **Hardware limitation**: SR-IOV VFs typically cap at ~40 Gbps
- **Optimal streams**: 16-32 parallel streams per connection
- **Resource management**: Critical to prevent process contention

#### Prerequisites for SR-IOV Mesh Testing
- Pods must be on the same physical node for SR-IOV connectivity
- Each pod requires unique IP address (static IPAM configuration)
- SR-IOV VFs should preferably be from the same physical function for optimal connectivity
- **Process management**: Avoid excessive concurrent iperf3 processes to prevent resource contention

## Prometheus SR-IOV Metrics Configuration

### Issue Resolution (2025-12-06)
Amazon Managed Prometheus agentless scraper connectivity issues fully resolved.

**Status**: ✅ **COMPLETE SUCCESS** - SR-IOV metrics now flowing into AMP workspace from both nodes

**Root Cause**: 
1. Missing security group rules for both EKS control plane and worker node security groups
2. AMP scraper cannot resolve Kubernetes service DNS names
3. Service needed NodePort exposure for external scraper access

**Actions Taken**:
1. Added security group rules allowing scraper (sg-035c5b3312c98286c) access to ports 9808 and 30808
   - EKS control plane security group: sg-01b44349ba5abba73
   - Worker node security group: sg-0470d60e559c65f7d (critical missing piece)
2. Changed service type from ClusterIP to NodePort (port 30808)
3. Updated scraper configuration to use node-based discovery instead of service discovery
4. Added required service annotations: `prometheus.io/port: "9808"` and `prometheus.io/path: "/metrics"`

**Final Status**: 
- ✅ Both nodes operational: ip-100-77-4-181.ec2.internal and ip-100-77-4-183.ec2.internal
- ✅ 32+ SR-IOV VF metrics per node flowing into AMP workspace
- ✅ Comprehensive VF statistics: rx_bytes, tx_bytes, rx_packets, tx_packets, device assignments

### Network Configuration Changes
- **Security Group Rules**: Added ingress rules for ports 9808 and 30808 to both security groups
- **Service Type**: Changed to NodePort exposing port 30808 on all nodes
- **Scraper Access**: Now uses node IPs matching successful node-exporter pattern

### Updated Prometheus Job Configuration
The `sriov-metrics` job now uses node-based discovery:

```yaml
- job_name: 'sriov-metrics'
  kubernetes_sd_configs:
    - role: node
  relabel_configs:
    - source_labels: [__address__]
      action: replace
      regex: ([^:]+):.*
      replacement: $1:30808
      target_label: __address__
    - source_labels: [__meta_kubernetes_node_name]
      action: replace
      target_label: instance
```

### Available SR-IOV Metrics in AMP
The exporter provides comprehensive SR-IOV metrics including:
- `sriov_vf_rx_bytes` - Virtual Function receive bytes (32+ VFs per node)
- `sriov_vf_tx_bytes` - Virtual Function transmit bytes  
- `sriov_vf_rx_packets` - Virtual Function receive packets
- `sriov_vf_tx_packets` - Virtual Function transmit packets
- `sriov_vf_rx_dropped` - Virtual Function receive drops
- `sriov_vf_tx_dropped` - Virtual Function transmit drops
- `sriov_kubepoddevice` - Pod device assignments
- `sriov_kubepodcpu` - Pod CPU assignments
- `sriov_cpu_info` - CPU topology information

### Verification Commands
```bash
# Query SR-IOV metrics in AMP workspace ws-178241d1-8310-4111-8b71-fc77f7b501a2
aws amp query --workspace-id ws-178241d1-8310-4111-8b71-fc77f7b501a2 --query-string 'up{job="sriov-metrics"}' --region us-east-1
aws amp query --workspace-id ws-178241d1-8310-4111-8b71-fc77f7b501a2 --query-string 'sriov_vf_rx_bytes' --region us-east-1

# Check service configuration
kubectl get service sriov-network-metrics-exporter -n monitoring -o yaml
kubectl get pods -n monitoring -l app.kubernetes.io/name=sriov-network-metrics-exporter
```

### Available SR-IOV Metrics
The exporter provides comprehensive SR-IOV metrics including:
- `sriov_vf_rx_bytes` - Virtual Function receive bytes
- `sriov_vf_tx_bytes` - Virtual Function transmit bytes  
- `sriov_vf_rx_packets` - Virtual Function receive packets
- `sriov_vf_tx_packets` - Virtual Function transmit packets
- `sriov_vf_rx_dropped` - Virtual Function receive drops
- `sriov_vf_tx_dropped` - Virtual Function transmit drops
- `sriov_kubepoddevice` - Pod device assignments
- `sriov_kubepodcpu` - Pod CPU assignments
- `sriov_cpu_info` - CPU topology information

### Verification Commands
```bash
# Check service annotations
kubectl get service sriov-network-metrics-exporter -n monitoring -o yaml | grep -A5 annotations

# Test metrics endpoint directly
kubectl run test-curl --rm -i --tty --image=curlimages/curl -- curl -s http://sriov-network-metrics-exporter.monitoring.svc.cluster.local:9808/metrics | grep sriov

# Query metrics in AMP workspace
# Use PromQL: sriov_vf_rx_bytes
```

## Notes

- **Whereabouts IPAM**: Disabled due to corruption issues, use static IP allocation
- **Node Assignment**: Pods are distributed across node1 and node2 based on nodeSelector
- **Privileged Containers**: Required for SR-IOV network interface access
- **VLAN Configuration**: Each NAD specifies appropriate VLAN tags for network segmentation
- **Performance Testing**: Use pod-based scripts to avoid host CPU consumption
