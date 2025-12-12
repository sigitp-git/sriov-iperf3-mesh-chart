# SR-IOV iperf3 Mesh Traffic Scripts

## Overview

This directory contains optimized scripts for generating full mesh iperf3 traffic between all pods (mesh, lb-bgp, mg) with **zero localhost CPU consumption**.

## Key Improvement

**Problem Solved**: Previous scripts caused 100% localhost CPU usage and system hangs because they spawned thousands of kubectl exec processes on localhost.

**Solution**: Optimized to run only **ONE kubectl exec per pod**, with all connection logic executing inside the pod itself.

## Traffic Profile

Updated to 10 Gbps bandwidth (previously 5 Gbps):

- ✅ **10 Gbps per connection** (`-b 10G`)
- ✅ **16 parallel streams** (`-P 16`)
- ✅ **Infinite duration** (`-t 0`)
- ✅ **Full mesh topology** - Every pod connects to every other pod
- ✅ **Dual interface** - VPC-CNI (eth0) + SR-IOV (net1)
- ✅ **Zero localhost CPU** - All processes run in pods

## Scripts

### `start-mesh.sh`

Starts full mesh iperf3 traffic across all 49 pods.

**Usage:**
```bash
./iperf3scripts/start-mesh.sh
```

**What it does:**
1. Starts iperf3 servers on ports 5201 (VPC-CNI) and 5202 (SR-IOV) on all pods
2. Creates full mesh connections: 49 pods × 48 connections × 2 interfaces = 4,704 connections
3. Uses VPC-CNI (eth0) for cross-node traffic
4. Uses SR-IOV (net1) for same-node high-performance traffic

**Performance:**
- Localhost CPU: Minimal (only 49 kubectl processes)
- Pod CPU: Distributed across all pods
- Network throughput: 10 Gbps per pod pair per interface
- Total mesh capacity: ~235 Tbps (49 pods × 48 connections × 2 interfaces × 10 Gbps)

## Architecture

```
Localhost (minimal CPU)
├── kubectl exec pod1 -- "start all connections" (1 process)
├── kubectl exec pod2 -- "start all connections" (1 process)
└── ... (49 total kubectl processes)

Pod1 (runs all connection logic internally)
├── iperf3 -c pod2_eth0 -p 5201 -b 10G -P 16 -t 0
├── iperf3 -c pod2_net1 -p 5202 -b 10G -P 16 -t 0
├── iperf3 -c pod3_eth0 -p 5201 -b 10G -P 16 -t 0
└── ... (96 iperf3 clients per pod)
```

## Verification

Check active connections in a pod:
```bash
kubectl exec mesh-pod-2 -- ps | grep iperf3 | grep -v defunct | wc -l
```

Expected: ~96 active iperf3 processes per pod (48 VPC-CNI + 48 SR-IOV)

## Technical Details

**Why this approach works:**

1. **Single kubectl exec per pod**: Reduces localhost overhead from 4,704 to 49 processes
2. **Shell loop inside pod**: All connection logic runs in pod's shell, not localhost
3. **Background processes**: iperf3 clients run as background jobs within the pod
4. **No kubectl in pods**: Script doesn't require kubectl binary inside pods

**Previous approach (failed):**
```bash
# This created 4,704 kubectl processes on localhost!
for src in pods; do
  for dst in pods; do
    kubectl exec $src -- iperf3 -c $dst ...  # Each line = 1 localhost process
  done
done
```

**Current approach (optimized):**
```bash
# This creates only 49 kubectl processes on localhost
for src in pods; do
  kubectl exec $src -- sh -c "
    for dst in all_pods; do
      iperf3 -c $dst ...  # Runs inside pod
    done
  "
done
```

## Troubleshooting

**Defunct processes**: Harmless zombie processes from previous failed attempts. They don't consume resources and will be cleaned when pods restart.

**No traffic**: Check if servers are running:
```bash
kubectl exec mesh-pod-2 -- ps | grep 'iperf3 -s'
```

**Localhost CPU high**: Ensure you're using the optimized `start-mesh.sh` script, not older versions.

## Version History

- **v3.0** (2025-12-12): Optimized for zero localhost CPU consumption + 10 Gbps bandwidth
  - Single kubectl exec per pod
  - All connection logic runs inside pods
  - Successfully handles 49 pods × 48 connections × 2 interfaces
  - Increased bandwidth from 5 Gbps to 10 Gbps per connection
  
- **v2.0** (deprecated): Multiple kubectl exec per connection - caused localhost CPU overload
- **v1.0** (deprecated): Initial implementation - caused system hangs
