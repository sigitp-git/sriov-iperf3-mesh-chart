# SR-IOV iperf3 Mesh Testing Helm Chart

This Helm chart deploys SR-IOV enabled pods with automated iperf3 mesh testing for EKS Outposts clusters.

## Project Structure

```
sriov-iperf3-mesh-chart/
├── Chart.yaml                           # Chart metadata
├── values.yaml                          # Configuration values  
├── README.md                            # This documentation
├── templates/                           # Helm templates
│   ├── network-attachment-definitions.yaml
│   ├── mesh-pods.yaml
│   ├── lb-bgp-pods.yaml
│   ├── mg-pods.yaml
│   └── NOTES.txt
└── pod-nad-yamls/                       # Original YAML manifests and scripts
    ├── README.md                        # Detailed SR-IOV documentation
    ├── same-node-mesh-test.sh           # Manual mesh testing script
    ├── *.yaml                           # Individual pod/NAD manifests
    └── deployment scripts
```

## Features

- ✅ **Complete 42-pod deployment** matching current production environment
- ✅ **24/7 iperf3 mesh testing** achieving 35+ Gbps throughput
- ✅ **Dual-node support** with optimized testing on both worker nodes
- ✅ **Zero localhost CPU consumption** - All testing runs within pods
- ✅ **Quick deployment/destruction** for rapid testing cycles
- ✅ **Complete package** - Includes original manifests and documentation

## Quick Start

```bash
# Navigate to chart directory
cd /home/ubuntu/sriov-iperf3-mesh-chart

# Deploy complete SR-IOV iperf3 mesh environment (42 pods)
helm install sriov-iperf3-mesh .

# Check deployment status
kubectl get pods -l app=sriov-mesh

# Monitor high-performance mesh testing (35+ Gbps)
kubectl exec mesh-pod-2 -- tail -f /tmp/optimized.log

# Complete removal and recreation
helm uninstall sriov-iperf3-mesh
helm install sriov-iperf3-mesh .
```

## Deployed Resources (42 Total Pods)

### High-Performance Mesh Pods (Node1) - 3 pods
- **mesh-pod-2**: 169.30.1.20/24 - Optimized iperf3 testing
- **mesh-pod-3**: 169.30.1.30/24 - Optimized iperf3 testing  
- **mesh-pod-4**: 169.30.1.40/24 - Optimized iperf3 testing
- **Performance**: 35+ Gbps per connection with unique IPs

### Load Balancer BGP Pods - 6 pods
- **Node1**: lb-bgp-pod-node1-n3/n4/n6 (3 pods)
- **Node2**: lb-bgp-pod-node2-n3/n4/n6 (3 pods) - Standard mesh testing
- **Networks**: VLAN 3, 4, 6 with shared IP (169.30.1.100/24)

### Management Pods - 33 pods
- **Node1**: mg-pod1-20-node1 (20 pods)
- **Node2**: mg-pod1-20-node2 + additional pods (13 pods)
- **Purpose**: General SR-IOV testing and resource utilization

## Current Status (2025-12-07)

**✅ 24/7 Continuous Testing Active**
- **Node1**: High-performance mesh with unique IPs achieving 35+ Gbps
- **Node2**: Standard mesh testing with shared IPs
- **Process Management**: Optimized to prevent resource contention
- **Zero Localhost Impact**: All testing contained within pods

## Original Manifests and Documentation

The `pod-nad-yamls/` directory contains:
- **Detailed documentation**: Complete SR-IOV setup and troubleshooting guide
- **Individual YAML manifests**: Original pod and NAD definitions
- **Manual testing scripts**: `same-node-mesh-test.sh` for on-demand testing
- **Performance optimization notes**: Lessons learned from traffic degradation incident
- **Prometheus metrics integration**: SR-IOV metrics configuration for AMP

## Performance Characteristics

- **Maximum throughput**: 35-40 Gbps per SR-IOV VF connection
- **Optimal streams**: 16-32 parallel streams per connection
- **Hardware limitation**: SR-IOV VFs typically cap at ~40 Gbps
- **Resource management**: Controlled concurrency prevents overload

## Monitoring

```bash
# Node1 optimized mesh (unique IPs)
kubectl exec mesh-pod-2 -- tail -f /tmp/optimized.log

# Node2 standard mesh (shared IP)
kubectl exec lb-bgp-pod-node2-n1 -- tail -f /tmp/node2-mesh.log

# Check process count (should be controlled)
kubectl exec mesh-pod-2 -- ps aux | grep iperf3 | wc -l

# Test manual throughput
kubectl exec mesh-pod-2 -- iperf3 -c 169.30.1.30 -p 5202 -t 10 -P 16
```

## Troubleshooting

### Common Issues

1. **Pods stuck in Pending**
   - Check SR-IOV resource availability: `kubectl describe nodes`
   - Verify device plugin: `kubectl logs -n kube-system -l app=sriov-device-plugin`

2. **Low throughput**
   - Check for process overload: `kubectl exec mesh-pod-2 -- ps aux | grep iperf3 | wc -l`
   - Restart testing: `kubectl exec mesh-pod-2 -- pkill iperf3`

3. **Network connectivity issues**
   - Verify NADs: `kubectl get network-attachment-definitions`
   - Check pod interfaces: `kubectl exec mesh-pod-2 -- ip addr show`

### Performance Optimization

- **Avoid excessive processes**: Keep iperf3 process count under control
- **Use optimal stream count**: 16-32 streams per connection
- **Monitor resource usage**: Prevent SR-IOV interface saturation
- **Clean restarts**: Kill old processes before starting new tests

## Architecture

```
Node1 (ip-100-77-4-181.ec2.internal)
├── mesh-pod-2 (169.30.1.20/24) ──┐
├── mesh-pod-3 (169.30.1.30/24) ──┼── 35+ Gbps mesh
├── mesh-pod-4 (169.30.1.40/24) ──┘
├── lb-bgp-pod-node1-n3/n4/n6
└── mg-pod1-20-node1

Node2 (ip-100-77-4-183.ec2.internal)
├── lb-bgp-pod-node2-n3/n4/n6 ──── Standard mesh
└── mg-pod1-20-node2
```

## Customization

### Adding New Pod Types

1. Create template in `templates/`
2. Add configuration to `values.yaml`
3. Update `NOTES.txt` for monitoring commands

### Modifying Network Configuration

1. Update `networks` section in `values.yaml`
2. Modify `network-attachment-definitions.yaml` template
3. Update pod annotations accordingly

## Version History

- **v1.0.0**: Initial release with dual-node mesh testing
  - Automated iperf3 deployment
  - Optimized configuration for 35+ Gbps
  - Process management and resource control
