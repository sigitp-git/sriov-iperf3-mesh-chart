# The static policy allows containers in Guaranteed pods with integer CPU requests access to exclusive CPUs on the node
# https://kubernetes.io/docs/tasks/administer-cluster/cpu-management-policies/
--node-labels=node.longhorn.io/create-default-disk=true,storage=longhorn,is_worker=true --topology-manager-policy=single-numa-node --cpu-manager-policy=static

# However the privileged pods doesn't respect the cpu limits
# https://stackoverflow.com/questions/48040183/do-privileged-containers-respect-cpu-limits
# https://docs.docker.com/engine/containers/run/#runtime-privilege-and-linux-capabilities
=================================================================
Hello Sunil and team, how do you achieve the below conclusion?
 
I have similar DPDK-TestPMD app in my lab with privileged: True:
 
spec:
  containers:
  - name:  ubuntu-mlnx-dpdk
    image: 291615555612.dkr.ecr.us-east-1.amazonaws.com/sigitp-ecr:ubuntu-mlnx-dpdk-amd64
    imagePullPolicy: IfNotPresent
    securityContext:
      privileged: true
      capabilities:
        add: ["CAP_NET_RAW", "NET_ADMIN", "SYS_TIME"]
    command: [ "/bin/bash", "-c", "--" ]
    args: [ "while true; do sleep 300000; done;" ]
    volumeMounts:
    - mountPath: /hugepages
      name: hugepage
    resources:
      requests:
        cpu: 33
        memory: 32Gi
        hugepages-1Gi: 8Gi
        amazon.com/bmn-mlx-sriov-pf3: '1'
        amazon.com/bmn-mlx-sriov-pf4: '1'
      limits:
        cpu: 33
        memory: 32Gi
        hugepages-1Gi: 8Gi
        amazon.com/bmn-mlx-sriov-pf3: '1'
        amazon.com/bmn-mlx-sriov-pf4: '1'
 
And I can confirm that my 33 vCPU request/limit for guaranteed allocation is applied by Kubelet.
Here’s the CPU allocation on the worker node "ubuntu-mlnx-dpdk": "49-64,144-160": which consumes 33 vCPU.
 
## ssh to the worker node
sh-5.2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0-47,65-95,97-143,161-191",
  "entries": {
    "a36ce0ef-3989-4bd8-993d-0fba17c44b89": {
      "ubuntu-netutils": "48"
    },
    "af9c544c-dbc1-40f6-9392-dc5187b8c04c": {
      "ubuntu-mlnx-dpdk": "49-64,144-160"
    },
    "ed292075-3565-4919-83dc-248e3bf09ead": {
      "ubuntu-frr": "96"
    }
  },
  "checksum": 470772457
}
sh-5.2$
 
Here’s my Kubelet extra arguments, please compare with yours, probably you don’t have the “--cpu-manager-policy=static”?
--node-labels=node.longhorn.io/create-default-disk=true,storage=longhorn,is_worker=true --topology-manager-policy=single-numa-node --cpu-manager-policy=static

====
ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node1  -- cat /sys/fs/cgroup/cpuset.cpus.effective
0-191
ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node2  -- cat /sys/fs/cgroup/cpuset.cpus.effective
0-191
ubuntu@ip-172-31-26-158:~$ 

ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node2  -- stat -fc %T /sys/fs/cgroup/
cgroup2fs
ubuntu@ip-172-31-26-158:~$ 

kubectl exec -it mlnx-dpdk-dsf-node1 -- cat /sys/fs/cgroup/$(cut -d: -f3 /proc/self/cgroup)/cpuset.cpus.effective

====
## cgroup2
sh-5.2$ sudo cat /var/lib/kubelet/cpu_manager_state | jq
{
  "policyName": "static",
  "defaultCpuSet": "0-47,65-95,97-143,161-191",
  "entries": {
    "a36ce0ef-3989-4bd8-993d-0fba17c44b89": {
      "ubuntu-netutils": "48"
    },
    "af9c544c-dbc1-40f6-9392-dc5187b8c04c": {
      "ubuntu-mlnx-dpdk": "49-64,144-160"
    },
    "ed292075-3565-4919-83dc-248e3bf09ead": {
      "ubuntu-frr": "96"
    }
  },
  "checksum": 470772457
}

sh-5.2$ stat -fc %T /sys/fs/cgroup/
cgroup2fs
sh-5.2$ 


=======
THE RIGHT FILE TO CHECK
=======
ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node1 -- cut -d: -f3 /proc/self/cgroup
/kubepods.slice/kubepods-podaf9c544c_dbc1_40f6_9392_dc5187b8c04c.slice/cri-containerd-01ebc0a24cc16888a08fc9bf1a1fa4cb22d683cedcb98f876a30fe4e42256efb.scope
ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node1 -- cat /sys/fs/cgroup/kubepods.slice/kubepods-podaf9c544c_dbc1_40f6_9392_dc5187b8c04c.slice/cri-containerd-01ebc0a24cc16888a08fc9bf1a1fa4cb22d683cedcb98f876a30fe4e42256efb.scope/cpuset.cpus.effective
49-64,144-160
ubuntu@ip-172-31-26-158:~$ 

ubuntu@ip-172-31-26-158:~$ kubectl exec -it mlnx-dpdk-dsf-node1 -- sh -c 'KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective'
49-64,144-160

kubectl exec -it test-samplepod -- cat /sys/fs/cgroup/cpuset.cpus.effective


======
Please refer to the discussion  at https://github.com/kubernetes/kubernetes/issues/119669
 
Key takeaway from this article:
- Since Kubernetes 1.24, the privileged container's /sys/fs/cgroup is getting overridden with host node's /sys/fs/cgroup. It's likely to the cgroup v2 support in kubelet.
- Due to this, when privileged is set to true, the command cat /sys/fs/cgroup/cpuset.cpus.effective at the container level returns the effective cpus for the whole node.
- When privileged is set to false,  cat /sys/fs/cgroup/cpuset.cpus.effective at the container level shows the effective cpus as expected for the container.
- So, with cgroup v2,  if the container is privileged, use cat /sys/fs/cgroup/$(cut -d: -f3 /proc/self/cgroup)/cpuset.cpus.effective to get the effective cpus for the container