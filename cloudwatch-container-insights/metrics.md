> Here are all the available metric names for CloudWatch Container Insights:

## Pod Metrics (13 metrics)
- pod_cpu_reserved_capacity - CPU capacity reserved per pod
- pod_cpu_utilization - CPU usage percentage by pods
- pod_cpu_utilization_over_pod_limit - CPU usage vs pod limit
- pod_gpu_request - GPU requests for pod
- pod_gpu_limit - Maximum GPUs assignable to pod
- pod_gpu_usage_total - GPUs allocated on pod
- pod_gpu_reserved_capacity - GPU reservation percentage
- pod_memory_reserved_capacity - Memory reserved for pods
- pod_memory_utilization - Memory usage percentage
- pod_memory_utilization_over_pod_limit - Memory usage vs pod limit
- pod_network_rx_bytes - Network bytes received per second
- pod_network_tx_bytes - Network bytes transmitted per second
- pod_number_of_container_restarts - Container restart count

## Node Metrics (15 metrics)
- node_cpu_limit - Maximum CPU units per node
- node_cpu_reserved_capacity - CPU reserved for node components
- node_cpu_usage_total - Total CPU units used
- node_cpu_utilization - CPU usage percentage
- node_gpu_limit - Total GPUs available on node
- node_gpu_usage_total - GPUs used by running pods
- node_gpu_reserved_capacity - GPU reservation percentage
- node_filesystem_utilization - File system usage percentage
- node_memory_limit - Maximum memory per node
- node_memory_reserved_capacity - Memory reserved percentage
- node_memory_utilization - Memory usage percentage
- node_memory_working_set - Memory in working set
- node_network_total_bytes - Total network bytes per second
- node_number_of_running_containers - Running containers per node
- node_number_of_running_pods - Running pods per node

## Cluster Metrics (2 metrics)
- cluster_failed_node_count - Failed worker nodes
- cluster_node_count - Total worker nodes

## Namespace Metrics (1 metric)
- namespace_number_of_running_pods - Running pods per namespace

## Service Metrics (1 metric)
- service_number_of_running_pods - Running pods per service

All metrics use the ContainerInsights namespace and require appropriate dimensions like ClusterName, PodName, Namespace, etc.
 ▸ Time: 20s

!>
