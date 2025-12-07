ubuntu@ip-10-255-255-86:~/cmg/24.7.R1$ kubectl describe pod lmg-statefulset-set-one-0 -n upf
Name:             lmg-statefulset-set-one-0
Namespace:        upf
Priority:         0
Service Account:  default
Node:             ip-10-254-0-83.ec2.internal/10.254.0.83
Start Time:       Thu, 19 Sep 2024 21:15:49 +0000
Labels:           app=lmg-statefulset-set-one
                  apps.kubernetes.io/pod-index=0
                  controller-revision-hash=lmg-statefulset-set-one-7f7b55d657
                  name=lmg-set-one
                  nasc=enable
                  statefulset.kubernetes.io/pod-name=lmg-statefulset-set-one-0
                  uuid=c65b185b-3394-4375-9999-185024342573
                  version=v1
Annotations:      k8s.v1.cni.cncf.io/network-status:
                    [{
                        "name": "aws-cni",
                        "interface": "dummy861eb6adfb9",
                        "ips": [
                            "10.254.0.247"
                        ],
                        "mac": "0",
                        "default": true,
                        "dns": {}
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net1",
                        "mac": "b2:5c:b6:1e:11:16",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:00.2"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net2",
                        "mac": "82:74:12:65:7e:c9",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:09.1"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net3",
                        "mac": "9a:fc:cf:07:92:cd",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:01.0"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net4",
                        "mac": "fe:8a:e9:17:ec:3c",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:08.2"
                            }
                        }
                    }]
                  k8s.v1.cni.cncf.io/networks: sriov-net-0,sriov-net-1,sriov-net-0,sriov-net-1
Status:           Running
IP:               10.254.0.247
IPs:
  IP:           10.254.0.247
Controlled By:  StatefulSet/lmg-statefulset-set-one
Containers:
  lmg:
    Container ID:  containerd://674d80a89df0ea3118e57dc612c66edf97dfd00b8b59aec1f895e896a7ea27ac
    Image:         harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1
    Image ID:      harbor.nokia-solution.com/library/lmg/lmg@sha256:98ed35c8f2e747497e7505246a8adf7ce516fecc695a49ac9d6fa05ae7fa5f08
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/sh
      -c
      ethtool -K net1 gro off; ethtool -K net2 gro off; ethtool -K net3 gro off; ethtool -K net4 gro off; sysctl -w net.ipv4.conf.default.rp_filter=0; ./iom /etc/sysconfig/lmg.cfg
    State:          Running
      Started:      Thu, 19 Sep 2024 21:15:53 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:                               24
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            128Gi
    Requests:
      cpu:                               24
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            128Gi
    Liveness:                            http-get http://:8080/healthz/liveness delay=10s timeout=5s period=30s #success=1 #failure=1
    Readiness:                           http-get http://:8080/healthz/readiness delay=15s timeout=5s period=30s #success=1 #failure=2
    Startup:                             http-get http://:8080/healthz/liveness delay=0s timeout=1s period=10s #success=1 #failure=60
    Environment:
      MY_POD_NAME:  lmg-statefulset-set-one-0 (v1:metadata.name)
      MY_CNF_UUID:  c65b185b-3394-4375-9999-185024342573
    Mounts:
      /etc/sysconfig/ from config-volume1 (rw)
      /hugepages from hugepage (rw)
      /logs/ from shared-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-f9kjp (ro)
  nok-analytics:
    Container ID:   containerd://271f94476ce00603a3fd140e3675f3c0850c6fc4cd5f86a50dae7d1b45f0e2ae
    Image:          harbor.nokia-solution.com/library/lmg/nasc:B-24.7.R1
    Image ID:       harbor.nokia-solution.com/library/lmg/nasc@sha256:4ccaa00286d9ca39f2314cb66ba4809c09b2d43e544cd6e0c9e6a7191fe5ef2c
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Thu, 19 Sep 2024 21:15:53 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     2
      memory:  1Gi
    Requests:
      cpu:     2
      memory:  1Gi
    Environment:
      MY_POD_NAME:           lmg-statefulset-set-one-0 (v1:metadata.name)
      MY_POD_IP:              (v1:status.podIP)
      CONFIG_READ_INTERVAL:  300
    Mounts:
      /etc/stats-exporter-sidecar/ from config-sidecar (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-f9kjp (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  shared-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  logs-volume-claim
    ReadOnly:   false
  config-sidecar:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      stats-sidecar-lmg
    Optional:  false
  config-volume1:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      lmg-set-one
    Optional:  false
  hugepage:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     HugePages
    SizeLimit:  <unset>
  kube-api-access-f9kjp:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Guaranteed
Node-Selectors:              <none>
Tolerations:                 kinara.com/bmn-sriov-numa0p0-pf1:NoSchedule op=Exists
                             kinara.com/bmn-sriov-numa0p1-pf2:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason          Age                   From               Message
  ----     ------          ----                  ----               -------
  Normal   Scheduled       7m35s                 default-scheduler  Successfully assigned upf/lmg-statefulset-set-one-0 to ip-10-254-0-83.ec2.internal
  Normal   AddedInterface  7m34s                 multus             Add eth0 [10.254.0.247/32] from aws-cni
  Normal   AddedInterface  7m33s                 multus             Add net1 [] from upf/sriov-net-0
  Normal   AddedInterface  7m33s                 multus             Add net2 [] from upf/sriov-net-1
  Normal   AddedInterface  7m32s                 multus             Add net3 [] from upf/sriov-net-0
  Normal   AddedInterface  7m32s                 multus             Add net4 [] from upf/sriov-net-1
  Normal   Pulled          7m31s                 kubelet            Container image "harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1" already present on machine
  Normal   Created         7m31s                 kubelet            Created container lmg
  Normal   Started         7m31s                 kubelet            Started container lmg
  Normal   Pulled          7m31s                 kubelet            Container image "harbor.nokia-solution.com/library/lmg/nasc:B-24.7.R1" already present on machine
  Normal   Created         7m31s                 kubelet            Created container nok-analytics
  Normal   Started         7m31s                 kubelet            Started container nok-analytics
  Warning  Unhealthy       7m5s (x3 over 7m25s)  kubelet            Startup probe failed: Get "http://10.254.0.247:8080/healthz/liveness": dial tcp 10.254.0.247:8080: connect: connection refused



ubuntu@ip-10-255-255-86:~/cmg/24.7.R1$ kubectl describe pod lmg-statefulset-set-two-0 -n upf
Name:             lmg-statefulset-set-two-0
Namespace:        upf
Priority:         0
Service Account:  default
Node:             ip-10-254-0-153.ec2.internal/10.254.0.153
Start Time:       Thu, 19 Sep 2024 21:15:49 +0000
Labels:           app=lmg-statefulset-set-two
                  apps.kubernetes.io/pod-index=0
                  controller-revision-hash=lmg-statefulset-set-two-f6bdb4c95
                  name=lmg-set-two
                  nasc=enable
                  statefulset.kubernetes.io/pod-name=lmg-statefulset-set-two-0
                  uuid=c65b185b-3394-4375-9999-185024342573
                  version=v1
Annotations:      k8s.v1.cni.cncf.io/network-status:
                    [{
                        "name": "aws-cni",
                        "interface": "dummy3d78c2a3eeb",
                        "ips": [
                            "10.254.0.172"
                        ],
                        "mac": "0",
                        "default": true,
                        "dns": {}
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net1",
                        "mac": "7a:6b:ee:68:d6:ea",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:00.5"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net2",
                        "mac": "8e:b6:19:15:38:4f",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:03.3"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net3",
                        "mac": "da:45:9d:1d:ea:2a",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:00.2"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net4",
                        "mac": "f6:b6:d0:bd:fa:92",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:02.3"
                            }
                        }
                    }]
                  k8s.v1.cni.cncf.io/networks: sriov-net-0,sriov-net-1,sriov-net-0,sriov-net-1
Status:           Running
IP:               10.254.0.172
IPs:
  IP:           10.254.0.172
Controlled By:  StatefulSet/lmg-statefulset-set-two
Containers:
  lmg:
    Container ID:  containerd://161b214f0501aa454c1f5df3e589928e4348269a1e421e3441742d1c6eaef839
    Image:         harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1
    Image ID:      harbor.nokia-solution.com/library/lmg/lmg@sha256:98ed35c8f2e747497e7505246a8adf7ce516fecc695a49ac9d6fa05ae7fa5f08
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/sh
      -c
      ethtool -K net1 gro off; ethtool -K net2 gro off; ethtool -K net3 gro off; ethtool -K net4 gro off; sysctl -w net.ipv4.conf.default.rp_filter=0; ./iom /etc/sysconfig/lmg.cfg
    State:          Running
      Started:      Thu, 19 Sep 2024 21:15:55 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:                               24
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            128Gi
    Requests:
      cpu:                               24
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            128Gi
    Liveness:                            http-get http://:8080/healthz/liveness delay=10s timeout=5s period=30s #success=1 #failure=1
    Readiness:                           http-get http://:8080/healthz/readiness delay=15s timeout=5s period=30s #success=1 #failure=2
    Startup:                             http-get http://:8080/healthz/liveness delay=0s timeout=1s period=10s #success=1 #failure=60
    Environment:
      MY_POD_NAME:  lmg-statefulset-set-two-0 (v1:metadata.name)
      MY_CNF_UUID:  c65b185b-3394-4375-9999-185024342573
    Mounts:
      /etc/sysconfig/ from config-volume1 (rw)
      /hugepages from hugepage (rw)
      /logs/ from shared-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-q9kg4 (ro)
  nok-analytics:
    Container ID:   containerd://1634245187708e864f08ce98ae35c2655c50e38eb9de1eec59b17294b36cdf96
    Image:          harbor.nokia-solution.com/library/lmg/nasc:B-24.7.R1
    Image ID:       harbor.nokia-solution.com/library/lmg/nasc@sha256:4ccaa00286d9ca39f2314cb66ba4809c09b2d43e544cd6e0c9e6a7191fe5ef2c
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Thu, 19 Sep 2024 21:15:55 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:     2
      memory:  1Gi
    Requests:
      cpu:     2
      memory:  1Gi
    Environment:
      MY_POD_NAME:           lmg-statefulset-set-two-0 (v1:metadata.name)
      MY_POD_IP:              (v1:status.podIP)
      CONFIG_READ_INTERVAL:  300
    Mounts:
      /etc/stats-exporter-sidecar/ from config-sidecar (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-q9kg4 (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  shared-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  logs-volume-claim
    ReadOnly:   false
  config-sidecar:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      stats-sidecar-lmg
    Optional:  false
  config-volume1:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      lmg-set-two
    Optional:  false
  hugepage:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     HugePages
    SizeLimit:  <unset>
  kube-api-access-q9kg4:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Guaranteed
Node-Selectors:              <none>
Tolerations:                 kinara.com/bmn-sriov-numa0p0-pf1:NoSchedule op=Exists
                             kinara.com/bmn-sriov-numa0p1-pf2:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type     Reason          Age                 From               Message
  ----     ------          ----                ----               -------
  Normal   Scheduled       8m11s               default-scheduler  Successfully assigned upf/lmg-statefulset-set-two-0 to ip-10-254-0-153.ec2.internal
  Normal   AddedInterface  8m8s                multus             Add eth0 [10.254.0.172/32] from aws-cni
  Normal   AddedInterface  8m8s                multus             Add net1 [] from upf/sriov-net-0
  Normal   AddedInterface  8m7s                multus             Add net2 [] from upf/sriov-net-1
  Normal   AddedInterface  8m6s                multus             Add net3 [] from upf/sriov-net-0
  Normal   AddedInterface  8m5s                multus             Add net4 [] from upf/sriov-net-1
  Normal   Pulled          8m5s                kubelet            Container image "harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1" already present on machine
  Normal   Created         8m5s                kubelet            Created container lmg
  Normal   Started         8m5s                kubelet            Started container lmg
  Normal   Pulled          8m5s                kubelet            Container image "harbor.nokia-solution.com/library/lmg/nasc:B-24.7.R1" already present on machine
  Normal   Created         8m5s                kubelet            Created container nok-analytics
  Normal   Started         8m5s                kubelet            Started container nok-analytics
  Warning  Unhealthy       7m40s (x3 over 8m)  kubelet            Startup probe failed: Get "http://10.254.0.172:8080/healthz/liveness": dial tcp 10.254.0.172:8080: connect: connection refused

ubuntu@ip-10-255-255-86:~/cmg/24.7.R1$ kubectl describe pod llb-statefulset-0 -n upf
Name:             llb-statefulset-0
Namespace:        upf
Priority:         0
Service Account:  default
Node:             ip-10-254-0-153.ec2.internal/10.254.0.153
Start Time:       Thu, 19 Sep 2024 21:15:49 +0000
Labels:           app=llb-statefulset
                  apps.kubernetes.io/pod-index=0
                  controller-revision-hash=llb-statefulset-57c69b4bcb
                  name=llb
                  statefulset.kubernetes.io/pod-name=llb-statefulset-0
                  uuid=c65b185b-3394-4375-9999-185024342573
                  version=v1
Annotations:      k8s.v1.cni.cncf.io/network-status:
                    [{
                        "name": "aws-cni",
                        "interface": "dummy47c0dee96f0",
                        "ips": [
                            "10.254.0.63"
                        ],
                        "mac": "0",
                        "default": true,
                        "dns": {}
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net1",
                        "mac": "9a:0c:25:7b:ae:c2",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:01.0"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net2",
                        "mac": "02:f2:1c:86:ba:11",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:02.4"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net3",
                        "mac": "5e:82:37:bb:b8:57",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:00.3"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net4",
                        "mac": "8a:1c:d8:4a:64:73",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:03.2"
                            }
                        }
                    }]
                  k8s.v1.cni.cncf.io/networks: sriov-net-0,sriov-net-1,sriov-net-0,sriov-net-1
Status:           Running
IP:               10.254.0.63
IPs:
  IP:           10.254.0.63
Controlled By:  StatefulSet/llb-statefulset
Containers:
  llb:
    Container ID:  containerd://3cd61cf34c624542f335ecd3bcbac451b844fb565e2a6af2609150ed93fda033
    Image:         harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1
    Image ID:      harbor.nokia-solution.com/library/lmg/lmg@sha256:98ed35c8f2e747497e7505246a8adf7ce516fecc695a49ac9d6fa05ae7fa5f08
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/sh
      -c
      ethtool -K net1 gro off; ethtool -K net2 gro off; ethtool -K net3 gro off; ethtool -K net4 gro off; ./iom /etc/sysconfig/llb.cfg
    State:          Running
      Started:      Thu, 19 Sep 2024 21:15:55 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:                               8
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            16Gi
    Requests:
      cpu:                               8
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            16Gi
    Environment:
      MY_POD_NAME:  llb-statefulset-0 (v1:metadata.name)
      MY_CNF_UUID:  c65b185b-3394-4375-9999-185024342573
    Mounts:
      /etc/sysconfig/ from config-volume1 (rw)
      /hugepages from hugepage (rw)
      /logs/ from shared-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-pvqqg (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  shared-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  logs-volume-claim
    ReadOnly:   false
  config-volume1:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      llb
    Optional:  false
  hugepage:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     HugePages
    SizeLimit:  <unset>
  kube-api-access-pvqqg:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Guaranteed
Node-Selectors:              <none>
Tolerations:                 kinara.com/bmn-sriov-numa0p0-pf1:NoSchedule op=Exists
                             kinara.com/bmn-sriov-numa0p1-pf2:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason          Age    From               Message
  ----    ------          ----   ----               -------
  Normal  Scheduled       8m46s  default-scheduler  Successfully assigned upf/llb-statefulset-0 to ip-10-254-0-153.ec2.internal
  Normal  AddedInterface  8m44s  multus             Add eth0 [10.254.0.63/32] from aws-cni
  Normal  AddedInterface  8m44s  multus             Add net1 [] from upf/sriov-net-0
  Normal  AddedInterface  8m43s  multus             Add net2 [] from upf/sriov-net-1
  Normal  AddedInterface  8m42s  multus             Add net3 [] from upf/sriov-net-0
  Normal  AddedInterface  8m41s  multus             Add net4 [] from upf/sriov-net-1
  Normal  Pulled          8m41s  kubelet            Container image "harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1" already present on machine
  Normal  Created         8m41s  kubelet            Created container llb
  Normal  Started         8m40s  kubelet            Started container llb


ubuntu@ip-10-255-255-86:~/cmg/24.7.R1$ kubectl describe pod llb-statefulset-1 -n upf
Name:             llb-statefulset-1
Namespace:        upf
Priority:         0
Service Account:  default
Node:             ip-10-254-0-83.ec2.internal/10.254.0.83
Start Time:       Thu, 19 Sep 2024 21:15:55 +0000
Labels:           app=llb-statefulset
                  apps.kubernetes.io/pod-index=1
                  controller-revision-hash=llb-statefulset-57c69b4bcb
                  name=llb
                  statefulset.kubernetes.io/pod-name=llb-statefulset-1
                  uuid=c65b185b-3394-4375-9999-185024342573
                  version=v1
Annotations:      k8s.v1.cni.cncf.io/network-status:
                    [{
                        "name": "aws-cni",
                        "interface": "dummyf863433cf90",
                        "ips": [
                            "10.254.0.108"
                        ],
                        "mac": "0",
                        "default": true,
                        "dns": {}
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net1",
                        "mac": "ce:0c:6f:80:94:f6",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:01.2"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net2",
                        "mac": "e2:74:63:a0:1b:e2",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:08.5"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-0",
                        "interface": "net3",
                        "mac": "be:0c:5b:c6:25:e7",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:00.3"
                            }
                        }
                    },{
                        "name": "upf/sriov-net-1",
                        "interface": "net4",
                        "mac": "66:69:b1:fd:79:e5",
                        "dns": {},
                        "device-info": {
                            "type": "pci",
                            "version": "1.1.0",
                            "pci": {
                                "pci-address": "0000:02:08.3"
                            }
                        }
                    }]
                  k8s.v1.cni.cncf.io/networks: sriov-net-0,sriov-net-1,sriov-net-0,sriov-net-1
Status:           Running
IP:               10.254.0.108
IPs:
  IP:           10.254.0.108
Controlled By:  StatefulSet/llb-statefulset
Containers:
  llb:
    Container ID:  containerd://ab98ed7026fa007e98a20895eb545c542675fca9668d3e0fddbfd43aa29d456a
    Image:         harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1
    Image ID:      harbor.nokia-solution.com/library/lmg/lmg@sha256:98ed35c8f2e747497e7505246a8adf7ce516fecc695a49ac9d6fa05ae7fa5f08
    Port:          <none>
    Host Port:     <none>
    Command:
      /bin/sh
      -c
      ethtool -K net1 gro off; ethtool -K net2 gro off; ethtool -K net3 gro off; ethtool -K net4 gro off; ./iom /etc/sysconfig/llb.cfg
    State:          Running
      Started:      Thu, 19 Sep 2024 21:15:59 +0000
    Ready:          True
    Restart Count:  0
    Limits:
      cpu:                               8
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            16Gi
    Requests:
      cpu:                               8
      hugepages-1Gi:                     2Gi
      kinara.com/bmn-sriov-numa0p0-pf1:  2
      kinara.com/bmn-sriov-numa0p1-pf2:  2
      memory:                            16Gi
    Environment:
      MY_POD_NAME:  llb-statefulset-1 (v1:metadata.name)
      MY_CNF_UUID:  c65b185b-3394-4375-9999-185024342573
    Mounts:
      /etc/sysconfig/ from config-volume1 (rw)
      /hugepages from hugepage (rw)
      /logs/ from shared-data (rw)
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-ds8wj (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True
  Initialized                 True
  Ready                       True
  ContainersReady             True
  PodScheduled                True
Volumes:
  shared-data:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  logs-volume-claim
    ReadOnly:   false
  config-volume1:
    Type:      ConfigMap (a volume populated by a ConfigMap)
    Name:      llb
    Optional:  false
  hugepage:
    Type:       EmptyDir (a temporary directory that shares a pod's lifetime)
    Medium:     HugePages
    SizeLimit:  <unset>
  kube-api-access-ds8wj:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   Guaranteed
Node-Selectors:              <none>
Tolerations:                 kinara.com/bmn-sriov-numa0p0-pf1:NoSchedule op=Exists
                             kinara.com/bmn-sriov-numa0p1-pf2:NoSchedule op=Exists
                             node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:
  Type    Reason          Age   From               Message
  ----    ------          ----  ----               -------
  Normal  Scheduled       9m8s  default-scheduler  Successfully assigned upf/llb-statefulset-1 to ip-10-254-0-83.ec2.internal
  Normal  AddedInterface  9m7s  multus             Add eth0 [10.254.0.108/32] from aws-cni
  Normal  AddedInterface  9m7s  multus             Add net1 [] from upf/sriov-net-0
  Normal  AddedInterface  9m6s  multus             Add net2 [] from upf/sriov-net-1
  Normal  AddedInterface  9m6s  multus             Add net3 [] from upf/sriov-net-0
  Normal  AddedInterface  9m5s  multus             Add net4 [] from upf/sriov-net-1
  Normal  Pulled          9m5s  kubelet            Container image "harbor.nokia-solution.com/library/lmg/lmg:B-24.7.R1" already present on machine
  Normal  Created         9m5s  kubelet            Created container llb
  Normal  Started         9m5s  kubelet            Started container llb


ubuntu@ip-10-255-255-86:~/cmg/24.7.R1$ kubectl get net-attach-def -n upf sriov-net-0 -o yaml
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  annotations:
    k8s.v1.cni.cncf.io/resourceName: kinara.com/bmn-sriov-numa0p0-pf1
    meta.helm.sh/release-name: upf
    meta.helm.sh/release-namespace: upf
  creationTimestamp: "2024-09-19T21:15:48Z"
  generation: 1
  labels:
    app.kubernetes.io/managed-by: Helm
  name: sriov-net-0
  namespace: upf
  resourceVersion: "540517"
  uid: 985e7f85-1e7a-49d6-befa-1dcfb5b37f33
spec:
  config: |
    {
        "type": "sriov",
        "cniVersion": "0.3.1",
        "name": "sriov-net-0",
        "spoofchk": "off",
        "trust": "on",
        "vlan_trunk": "301-302,1000-2000",
        "ipam": {}
    }
ubuntu@ip-10-255-255-86:~/cmg/24.7.R1$ kubectl get net-attach-def -n upf sriov-net-1 -o yaml
apiVersion: k8s.cni.cncf.io/v1
kind: NetworkAttachmentDefinition
metadata:
  annotations:
    k8s.v1.cni.cncf.io/resourceName: kinara.com/bmn-sriov-numa0p1-pf2
    meta.helm.sh/release-name: upf
    meta.helm.sh/release-namespace: upf
  creationTimestamp: "2024-09-19T21:15:48Z"
  generation: 1
  labels:
    app.kubernetes.io/managed-by: Helm
  name: sriov-net-1
  namespace: upf
  resourceVersion: "540514"
  uid: 1089ffb3-5b12-4182-9ba2-ca41c84ab83a
spec:
  config: |
    {
        "type": "sriov",
        "cniVersion": "0.3.1",
        "name": "sriov-net-1",
        "spoofchk": "off",
        "trust": "on",
        "vlan_trunk": "301-302,1000-2000",
        "ipam": {}
    }
