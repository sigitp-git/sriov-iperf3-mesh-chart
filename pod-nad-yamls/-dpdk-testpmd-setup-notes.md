1. DPDK-TX
======================================
ifconfig net1
ethtool -i net1
KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective
./build/app/dpdk-testpmd -l 48-64,144-159 -n 6 -a 0001:16:01.2,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=169.30.1.2,169.30.1.3 --eth-peer=0,aa:64:62:7a:97:27
--------------------------------------
export KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); export CPU=$(cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective)
echo ${CPU}

export PCI=$(ethtool -i net1 | grep bus-info | awk '{print $2}')
echo ${PCI}

export IP=$(ifconfig net1 | grep inet | awk '{print $2}')
echo ${IP}

./build/app/dpdk-testpmd -l ${CPU} -n 6 -a ${PCI},mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test --socket-mem=4096,4096 --proc-type=auto -- --mbcache=512 --burst=64 --nb-cores=32 --rxq=24 --txq=24 -i --rxd=8192 --txd=8192 --forward-mode=txonly --txonly-multi-flow --tx-ip=${IP},169.30.1.5 --eth-peer=0,62:3e:f7:19:8e:93

#optional
lspci -v -nn -mm -k -s ${PCI}
--socket-mem=8192,0

2. DPDK-RX
======================================
ifconfig net1
ethtool -i net1
KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective
./build/app/dpdk-testpmd -l 65-80,160-176 -a 0001:16:00.7,mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test -- --nb-cores=32 --rxq=24 --txq=24 -i --forward-mode=rxonly --eth-peer=0,2e:61:54:1c:3d:73 --stats-period 5

--------------------------------------
export KUBEPOD_SLICE=$(cut -d: -f3 /proc/self/cgroup); export CPU=$(cat /sys/fs/cgroup$KUBEPOD_SLICE/cpuset.cpus.effective)
echo ${CPU}

export PCI=$(ethtool -i net1 | grep bus-info | awk '{print $2}')
echo ${PCI}

export IP=$(ifconfig net1 | grep inet | awk '{print $2}')
echo ${IP}

./build/app/dpdk-testpmd -l ${CPU} -a ${PCI},mprq_en=1,rxqs_min_mprq=1,mprq_log_stride_num=9,txq_inline_mpw=128,rxq_pkt_pad_en=1 --file-prefix sigitp-dpdk-test -- --nb-cores=32 --rxq=24 --txq=24 -i --forward-mode=rxonly --eth-peer=0,12:63:7e:96:46:82 --stats-period 5

#optional
lspci -v -nn -mm -k -s ${PCI}
--socket-mem=8192,0

3. Modifying Huge Pages Number
======================================
grep Hugepagesize /proc/meminfo
echo 32 > /proc/sys/vm/nr_hugepages or sysctl -w vm.nr_hugepages=32
permanent: echo "vm.nr_hugepages=512" >> /etc/sysctl.conf
grep HugePages_Total /proc/meminfo
grep HugePages_Free /proc/meminfo
grep MemFree /proc/meminfo
service kubelet restart
service kubelet status

4. Adding VF to PF
======================================
vim /bin/create-virtual-function.sh
change VF value to 0 before changing to new value (16, 32, more, depends on firmware version)
/bin/create-virtual-function.sh

5. SRIOV Metrics Exporter, worker node reinstall
======================================
helm uninstall prometheus-for-amp prometheus-community/prometheus -n prometheus
kubectl delete pvc storage-prometheus-for-amp-alertmanager-0 -n prometheus
kubectl delete pvc storage-volume-prometheus-for-amp-server-0 -n prometheus
    #note that pv and pvc created automatically by helm chart utilizing storageclass

IAM_PROXY_PROMETHEUS_ROLE_ARN=arn:aws:iam::291615555612:role/EKS-AMP-ServiceAccount-Role
WORKSPACE_ID=ws-23c82b83-eaeb-480f-b9e8-c2e788025465
AWS_REGION=us-east-1

helm install prometheus-for-amp prometheus-community/prometheus -n prometheus -f ./amp_ingest_override_values-storageclass-modify.yaml \--set serviceAccounts.server.annotations."eks\.amazonaws\.com/role-arn"="${IAM_PROXY_PROMETHEUS_ROLE_ARN}" \--set server.remoteWrite[0].url="https://aps-workspaces.${AWS_REGION}.amazonaws.com/workspaces/${WORKSPACE_ID}/api/v1/remote_write" \--set server.remoteWrite[0].sigv4.region=${AWS_REGION}

#amp-config-map
kubectl apply -f cm-prometheus-for-amp-server-n-prometheus-with-sriov-DEV1.yaml --force

#sriov-metrics-exporter
kubectl label node ip-10-0-62-173.ec2.internal feature.node.kubernetes.io/network-sriov.capable="true"

6. HugePages Modification for EKS Worker Node
======================================
sh-5.2$ grep Hugepagesize /proc/meminfo
Hugepagesize:    1048576 kB

sh-5.2$ grep HugePages_Total /proc/meminfo
HugePages_Total:       8
sh-5.2$

sh-5.2$ cat /proc/sys/vm/nr_hugepages
8
sh-5.2$

## MODIFICATION OF HUGEPAGES NUMBER, NO RESTART NEEDED

[root@ip-10-0-48-74 bin]# sysctl -w vm.nr_hugepages=32
vm.nr_hugepages = 32
[root@ip-10-0-48-74 bin]#

[root@ip-10-0-48-74 bin]# echo "vm.nr_hugepages=32" >> /etc/sysctl.conf
[root@ip-10-0-48-74 bin]# cat /etc/sysctl.conf
fs.inotify.max_user_watches=524288
fs.inotify.max_user_instances=8192
vm.max_map_count=524288
kernel.pid_max=4194304
vm.nr_hugepages=32
[root@ip-10-0-48-74 bin]#

[root@ip-10-0-48-74 bin]# grep HugePages_Total /proc/meminfo
HugePages_Total:      32
[root@ip-10-0-48-74 bin]#

[root@ip-10-0-48-74 bin]# grep HugePages_Free /proc/meminfo
HugePages_Free:       24
[root@ip-10-0-48-74 bin]#

[root@ip-10-0-48-74 bin]# grep MemFree /proc/meminfo
MemFree:        1012834412 kB
[root@ip-10-0-48-74 bin]#

## RESTART KUBELET ON WORKER NODE
[root@ip-10-0-48-74 ~]# systemctl status kubelet
● kubelet.service - Kubernetes Kubelet
     Loaded: loaded (/etc/systemd/system/kubelet.service; disabled; preset: disabled)
     Active: active (running) since Wed 2025-01-08 21:45:33 UTC; 1 day 21h ago
       Docs: https://github.com/kubernetes/kubernetes
   Main PID: 18560 (kubelet)
      Tasks: 112 (limit: 629145)
     Memory: 177.3M
        CPU: 1h 30min 22.144s
     CGroup: /runtime.slice/kubelet.service
             └─18560 /usr/bin/kubelet --cloud-provider=external --hostname-override=ip-10-0-48-74.ec2.internal --config=/etc/kubernetes/kubelet/config.json --config-dir=/etc/kubernetes/kubelet/config.json.d --kubeconfig=/var/lib/kubele>

Jan 10 16:59:27 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:27.123028   18560 state_mem.go:80] "Updated desired CPUSet" podUID="f89180c9-7d48-4e64-860f-03cf04c25ad9" containerName="instance-manager" cpuSet="0-47,65-143,160-1>
Jan 10 16:59:27 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:27.130856   18560 state_mem.go:80] "Updated desired CPUSet" podUID="836e359d-9757-4232-84b3-c44cfa669547" containerName="prometheus-server-configmap-reload" cpuSet=>
Jan 10 16:59:27 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:27.131667   18560 kubelet.go:2448] "SyncLoop UPDATE" source="api" pods=["default/mlnx-dpdk-1001-1002-node2-tx"]
Jan 10 16:59:27 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:27.139799   18560 state_mem.go:80] "Updated desired CPUSet" podUID="836e359d-9757-4232-84b3-c44cfa669547" containerName="prometheus-server" cpuSet="0-47,65-143,160->
Jan 10 16:59:27 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:27.262353   18560 state_mem.go:80] "Updated desired CPUSet" podUID="7ba44264-323d-4caa-87ec-fb1c69608d8d" containerName="node-exporter" cpuSet="0-47,65-143,160-191"
Jan 10 16:59:27 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:27.292468   18560 state_mem.go:80] "Updated desired CPUSet" podUID="e75cf515-125f-47c1-9e89-70bd3e8aa4e1" containerName="ubuntu-mlnx-dpdk" cpuSet="48-64,144-159"
Jan 10 16:59:28 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:28.265230   18560 kubelet.go:2473] "SyncLoop (PLEG): event for pod" pod="default/mlnx-dpdk-1001-1002-node2-tx" event={"ID":"e75cf515-125f-47c1-9e89-70bd3e8aa4e1","T>
Jan 10 16:59:28 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:28.265256   18560 kubelet.go:2473] "SyncLoop (PLEG): event for pod" pod="default/mlnx-dpdk-1001-1002-node2-tx" event={"ID":"e75cf515-125f-47c1-9e89-70bd3e8aa4e1","T>
Jan 10 16:59:28 ip-10-0-48-74.ec2.internal kubelet[18560]: I0110 16:59:28.424377   18560 pod_startup_latency_tracker.go:104] "Observed pod startup duration" pod="default/mlnx-dpdk-1001-1002-node2-tx" podStartSLOduration=7.424367882 pod>
Jan 10 18:51:43 ip-10-0-48-74.ec2.internal kubelet[18560]: E0110 18:51:43.340831   18560 server.go:917] query parameter "port" is required
[root@ip-10-0-48-74 ~]# ps ax | grep kubelet
  18560 ?        Ssl   88:59 /usr/bin/kubelet --cloud-provider=external --hostname-override=ip-10-0-48-74.ec2.internal --config=/etc/kubernetes/kubelet/config.json --config-dir=/etc/kubernetes/kubelet/config.json.d --kubeconfig=/var/lib/kubelet/kubeconfig --image-credential-provider-bin-dir=/etc/eks/image-credential-provider --image-credential-provider-config=/etc/eks/image-credential-provider/config.json --node-ip=10.0.48.74 --node-labels=node.longhorn.io/create-default-disk=true,storage=longhorn,is_worker=true --topology-manager-policy=single-numa-node --cpu-manager-policy=static
  22029 ?        Ssl    0:37 sriov-exporter --path.kubecgroup=/host/kubecgroup --path.sysbuspci=/host/sys/bus/pci/devices/ --path.sysclassnet=/host/sys/class/net/ --path.cpucheckpoint=/host/cpu_manager_state --path.kubeletsocket=/host/kubelet.sock --collector.kubepoddevice=true --collector.vfstatspriority=sysfs,netlink
 103015 ?        Ssl    0:05 /csi-node-driver-registrar --v=2 --csi-address=/csi/csi.sock --kubelet-registration-path=/var/lib/kubelet/plugins/driver.longhorn.io/csi.sock
3534266 pts/1    S+     0:00 grep --color=auto kubelet

[root@ip-10-0-48-74 ~]# systemctl restart kubelet

[root@ip-10-0-48-74 ~]# systemctl status kubelet
● kubelet.service - Kubernetes Kubelet
     Loaded: loaded (/etc/systemd/system/kubelet.service; disabled; preset: disabled)
     Active: active (running) since Fri 2025-01-10 19:11:19 UTC; 3s ago
       Docs: https://github.com/kubernetes/kubernetes
    Process: 3535355 ExecStartPre=/sbin/iptables -P FORWARD ACCEPT -w 5 (code=exited, status=0/SUCCESS)
   Main PID: 3535357 (kubelet)
      Tasks: 32 (limit: 629145)
     Memory: 51.5M
        CPU: 1.165s
     CGroup: /runtime.slice/kubelet.service
             └─3535357 /usr/bin/kubelet --cloud-provider=external --hostname-override=ip-10-0-48-74.ec2.internal --config=/etc/kubernetes/kubelet/config.json --config-dir=/etc/kubernetes/kubelet/config.json.d --kubeconfig=/var/lib/kube>

Jan 10 19:11:21 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:21.512711 3535357 operation_generator.go:664] "MountVolume.MountDevice succeeded for volume \"pvc-0f7e3000-e177-451a-8b37-d30b4ecee2a3\" (UniqueName: \"kubernetes>
Jan 10 19:11:21 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:21.594421 3535357 operation_generator.go:721] "MountVolume.SetUp succeeded for volume \"pvc-0f7e3000-e177-451a-8b37-d30b4ecee2a3\" (UniqueName: \"kubernetes.io/cs>
Jan 10 19:11:21 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:21.804827 3535357 kubelet.go:2545] "SyncLoop (probe)" probe="readiness" status="" pod="prometheus/prometheus-for-amp-prometheus-pushgateway-7697947457-xhk9b"
Jan 10 19:11:21 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:21.805434 3535357 kubelet.go:2545] "SyncLoop (probe)" probe="readiness" status="ready" pod="prometheus/prometheus-for-amp-prometheus-pushgateway-7697947457-xhk9b"
Jan 10 19:11:22 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:22.496383 3535357 kubelet.go:2545] "SyncLoop (probe)" probe="startup" status="unhealthy" pod="prometheus/prometheus-for-amp-server-0"
Jan 10 19:11:22 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:22.629558 3535357 kubelet.go:2545] "SyncLoop (probe)" probe="readiness" status="" pod="longhorn-system/longhorn-manager-s8qfr"
Jan 10 19:11:22 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:22.630592 3535357 kubelet.go:2545] "SyncLoop (probe)" probe="readiness" status="ready" pod="longhorn-system/longhorn-manager-s8qfr"
Jan 10 19:11:22 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:22.954539 3535357 kubelet.go:2545] "SyncLoop (probe)" probe="readiness" status="" pod="prometheus/prometheus-for-amp-server-0"
Jan 10 19:11:22 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:22.954581 3535357 prober_manager.go:312] "Failed to trigger a manual run" probe="Readiness"
Jan 10 19:11:22 ip-10-0-48-74.ec2.internal kubelet[3535357]: I0110 19:11:22.955166 3535357 kubelet.go:2545] "SyncLoop (probe)" probe="readiness" status="ready" pod="prometheus/prometheus-for-amp-server-0"

[root@ip-10-0-48-74 ~]#

### VALIDATE WITH KUBECTL
ubuntu@cloud9-sigitp:~$ kubectl describe node ip-10-0-48-74.ec2.internal
Name:               ip-10-0-48-74.ec2.internal
Roles:              <none>
Labels:             beta.kubernetes.io/arch=amd64
                    beta.kubernetes.io/instance-type=bmn-sf2.metal-32xl
                    beta.kubernetes.io/os=linux
                    failure-domain.beta.kubernetes.io/region=us-east-1
                    failure-domain.beta.kubernetes.io/zone=us-east-1a
                    feature.node.kubernetes.io/network-sriov.capable=true
                    is_worker=true
                    k8s.io/cloud-provider-aws=99c4e1dcd3f7e7aeb1ccff94f6ff1710
                    kubernetes.io/arch=amd64
                    kubernetes.io/clustername=kinara-dev1
                    kubernetes.io/hostname=ip-10-0-48-74.ec2.internal
                    kubernetes.io/os=linux
                    node.kubernetes.io/instance-type=bmn-sf2.metal-32xl
                    node.longhorn.io/create-default-disk=true
                    storage=longhorn
                    topology.k8s.aws/zone-id=use1-az6
                    topology.kubernetes.io/region=us-east-1
                    topology.kubernetes.io/zone=us-east-1a
Annotations:        alpha.kubernetes.io/provided-node-ip: 10.0.48.74
                    csi.volume.kubernetes.io/nodeid: {"driver.longhorn.io":"ip-10-0-48-74.ec2.internal"}
                    node.alpha.kubernetes.io/ttl: 0
                    volumes.kubernetes.io/controller-managed-attach-detach: true
CreationTimestamp:  Mon, 28 Oct 2024 18:37:33 +0000
Taints:             <none>
Unschedulable:      false
Lease:
  HolderIdentity:  ip-10-0-48-74.ec2.internal
  AcquireTime:     <unset>
  RenewTime:       Fri, 10 Jan 2025 19:12:02 +0000
Conditions:
  Type             Status  LastHeartbeatTime                 LastTransitionTime                Reason                       Message
  ----             ------  -----------------                 ------------------                ------                       -------
  MemoryPressure   False   Fri, 10 Jan 2025 19:11:20 +0000   Wed, 08 Jan 2025 21:45:35 +0000   KubeletHasSufficientMemory   kubelet has sufficient memory available
  DiskPressure     False   Fri, 10 Jan 2025 19:11:20 +0000   Wed, 08 Jan 2025 21:45:35 +0000   KubeletHasNoDiskPressure     kubelet has no disk pressure
  PIDPressure      False   Fri, 10 Jan 2025 19:11:20 +0000   Wed, 08 Jan 2025 21:45:35 +0000   KubeletHasSufficientPID      kubelet has sufficient PID available
  Ready            True    Fri, 10 Jan 2025 19:11:20 +0000   Wed, 08 Jan 2025 21:45:35 +0000   KubeletReady                 kubelet is posting ready status
Addresses:
  InternalIP:   10.0.48.74
  ExternalIP:   34.207.105.185
  InternalDNS:  ip-10-0-48-74.ec2.internal
  Hostname:     ip-10-0-48-74.ec2.internal
Capacity:
  cpu:                           192
  ephemeral-storage:             3710859656Ki
  hugepages-1Gi:                 32Gi
  hugepages-2Mi:                 0
  kinara.com/bmn-mlx-sriov-pf1:  10
  kinara.com/bmn-mlx-sriov-pf2:  10
  kinara.com/bmn-mlx-sriov-pf3:  10
  kinara.com/bmn-mlx-sriov-pf4:  10
  memory:                        1056600096Ki
  pods:                          737
Allocatable:
  cpu:                           191450m
  ephemeral-storage:             3418854511484
  hugepages-1Gi:                 32Gi
  hugepages-2Mi:                 0
  kinara.com/bmn-mlx-sriov-pf1:  10
  kinara.com/bmn-mlx-sriov-pf2:  10
  kinara.com/bmn-mlx-sriov-pf3:  10
  kinara.com/bmn-mlx-sriov-pf4:  10
  memory:                        1014380576Ki
  pods:                          737
System Info:
  Machine ID:                 ec27f1c4fc6918f4f6a0b746de7a97d8
  System UUID:                ec29c3e5-7265-acf0-9558-ae2470d63d92
  Boot ID:                    3d08fedb-ee44-4a2f-bbd6-8fd5d94a059f
  Kernel Version:             6.1.109-120.189.amzn2023.x86_64
  OS Image:                   Amazon Linux 2023.5.20240819
  Operating System:           linux
  Architecture:               amd64
  Container Runtime Version:  containerd://1.7.20
  Kubelet Version:            v1.30.2-eks-1552ad0
  Kube-Proxy Version:         v1.30.2-eks-1552ad0
ProviderID:                   aws:///us-east-1a/i-0a93eee4e9455f324



7. Root history launch new node
======================================
[root@ip-10-0-62-173 ~]# history
    1  cd
    2  cd /home/ec2-user/
    3  ls
    4  rpm -ivh kernel-6.1.109-120.189.amzn2023.x86_64.rpm
    5  sudo reboot
    6  cd
    7  lsmod | grep mlx
    8  grep MLX /boot/config-6.1.109-120.189.amzn2023.x86_64
    9  sudo modprobe mlx5_core
   10  sudo modprobe mlx5_ib
   11  lsmod | grep mlx
   12  cd
   13  vim /etc/pm/power.d/node-init-script.sh
   14  vi /etc/pm/power.d/node-init-script.sh
   15  vi /etc/pm/power.d/node-init-script.sh
   16  yum update
   17  yum install vim
   18  ping
   19  yum install net-tools -y
   20  yum install -y net-tools tcpdump vim iperf3 iftop ethtool netcat iputils-ping wget curl iproute2 dnsutils telnet git
   21  yum install -y net-tools
   22  yum install -y tcpdump
   23  yum install -y vim
   24  yum install -y iperf
   25  yum install -y iftop
   26  yum install -y ethtool
   27  yum install -y netcat
   28  yum install -y iputils-ping
   29  yum install -y iputils
   30  yum install -y wget
   31  yum install -y curl
   32  yum install -y curl
   33  cur
   34  yum install -y iproute
   35  yum install -y iproute2
   36  yum install -y dnsutils
   37  yum install -y telent
   38  yum install -y telnet
   39  yum install -y git
   40  yum install -y lshw
   41  history
   42  cat /etc/pm/power.d/node-init-script.sh
   43  lsmod | grep mlx
   44  vim /etc/pm/power.d/node-init-script.sh
   45  uname -r
   46  grep MLX /boot/config-6.1.109-120.189.amzn2023.x86_64
   47  uname -r
   48  cd
   49  exit
   50  cd
   51  cd
   52  vim /bin/create-virtual-function.sh
   53  cd
   54  cat /bin/create-virtual-function.sh
   55  vim /etc/systemd/system/createvf.service
   56  cd /etc/systemd/system
   57  ls
   58  cat nodeadm-config.service
   59  cd
   60  cat /bin/create-virtual-function.sh
   61  vim /bin/create-virtual-function.sh
   62  vim /bin/create-virtual-function.sh
   63  cat /bin/create-virtual-function.sh
   64  exit
   65  cd
   66  vim /bin/create-virtual-function.sh
   67  cat /etc/systemd/system/createvf.service
   68  cd
   69  chmod u+x /bin/create-virtual-function.sh
   70  /bin/create-virtual-function.sh
   71  exit
   72  cd /bin/
   73  ls
   74  cat create-virtual-function.sh
   75  vim create-virtual-function.sh
   76  cat create-virtual-function.sh
   77  ./create-virtual-function.sh
   78  ip -d link show
   79  cd
   80  cat /proc/sys/vm/nr_hugepages
   81  echo 32 > /proc/sys/vm/nr_hugepages
   82  cat /etc/sysctl.conf
   83  echo "vm.nr_hugepages=32" >> /etc/sysctl.conf
   84  grep HugePages_Total /proc/meminfo
   85  service kubelet status
   86  service kubelet restart
   87  cd
   88  history