# SR-IOV iperf3 Mesh Traffic Scripts

## Overview

This directory contains optimized scripts for generating full mesh iperf3 traffic between all pods (mesh, lb-bgp, mg) with **zero localhost CPU consumption**.

## Key Improvement

**Problem Solved**: Previous scripts caused 100% localhost CPU usage and system hangs because they spawned thousands of kubectl exec processes on localhost.

**Solution**: Optimized to run only **ONE kubectl exec per pod**, with all connection logic executing inside the pod itself.

## Traffic Profile

Updated to 20 Gbps bandwidth (previously 5 Gbps):

- ✅ **20 Gbps per connection** (`-b 20G`)
- ✅ **16 parallel streams** (`-P 32`)
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
- Network throughput: 20 Gbps per pod pair per interface
- Total mesh capacity: ~470 Tbps (49 pods × 48 connections × 2 interfaces × 20 Gbps)

### `add-cpu-load.sh`

Adds additional iperf3 traffic to maximize pod CPU utilization without killing existing traffic.

**Usage:**
```bash
./iperf3scripts/add-cpu-load.sh
```

**What it does:**
1. Starts 10 additional iperf3 servers per pod (ports 5203-5212)
2. Adds 10 connections per pod pair (5 VPC-CNI + 5 SR-IOV)
3. Creates 864 additional iperf3 processes per pod
4. Does NOT interfere with existing traffic on ports 5201-5202

**Performance:**
- Total processes per pod: ~960 (96 original + 864 new)
- Multiplies CPU load by ~11x
- Preserves all existing mesh traffic

### `monitor-mesh.sh`

Monitor iperf3 processes across all pods with parallel execution.

**Usage:**
```bash
./iperf3scripts/monitor-mesh.sh
```

**What it does:**
- Checks all 49 pods in parallel
- Shows active iperf3 process count per pod
- Expected: ~96 processes (baseline) or ~960 processes (with add-cpu-load.sh)

## Architecture

```
Localhost (minimal CPU)
├── kubectl exec pod1 -- "start all connections" (1 process)
├── kubectl exec pod2 -- "start all connections" (1 process)
└── ... (49 total kubectl processes)

Pod1 (runs all connection logic internally)
├── iperf3 -c pod2_eth0 -p 5201 -b 20G -P 32 -t 0
├── iperf3 -c pod2_net1 -p 5202 -b 20G -P 32 -t 0
├── iperf3 -c pod3_eth0 -p 5201 -b 20G -P 32 -t 0
└── ... (96 iperf3 clients per pod)
```

## Verification

Check active connections in a pod:
```bash
kubectl exec mesh-pod-2 -- ps | grep iperf3 | grep -v defunct | wc -l
```

Monitor all 49 pods (parallel execution):
```bash
./iperf3scripts/monitor-mesh.sh
```

Watch continuously:
```bash
watch -n 5 ./iperf3scripts/monitor-mesh.sh
```

Expected process counts:
- **Baseline (start-mesh.sh only)**: ~96 active iperf3 processes per pod (48 VPC-CNI + 48 SR-IOV)
- **High CPU load (with add-cpu-load.sh)**: ~960 active iperf3 processes per pod (96 original + 864 additional)

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

**Script hangs**: Fixed in v3.1 - removed blocking `wait` commands. Script now completes in ~15 seconds.

**Traffic stops after 45 minutes**: Fixed in v3.1 - added `nohup` to detach iperf3 processes from shell lifecycle.

**Defunct processes**: Harmless zombie processes from previous failed attempts. They don't consume resources and will be cleaned when pods restart.

**No traffic**: Check if servers are running:
```bash
kubectl exec mesh-pod-2 -- ps | grep 'iperf3 -s'
```

**Localhost CPU high**: Ensure you're using the optimized `start-mesh.sh` script, not older versions.

## Version History

- **v3.1** (2025-12-13): Fixed continuous traffic issues
  - Added `nohup` to prevent process termination when shell exits
  - Removed blocking `wait` commands that caused infinite hangs
  - Increased server startup wait from 3 to 10 seconds
  - Traffic now runs continuously without 45-minute dropout
  
- **v3.0** (2025-12-12): Optimized for zero localhost CPU consumption + 20 Gbps bandwidth
  - Single kubectl exec per pod
  - All connection logic runs inside pods
  - Successfully handles 49 pods × 48 connections × 2 interfaces
  - Increased bandwidth from 5 Gbps to 20 Gbps per connection
  
- **v2.0** (deprecated): Multiple kubectl exec per connection - caused localhost CPU overload
- **v1.0** (deprecated): Initial implementation - caused system hangs
