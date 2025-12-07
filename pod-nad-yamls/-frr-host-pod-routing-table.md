==============================================================================================
### N3 Routing Table
root@lb-bgp-pod-node1-n3:/# ip route
default via 169.254.1.1 dev eth0
10.81.100.100 dev lo scope link
169.30.1.0/24 dev net1 proto kernel scope link src 169.30.1.2
169.30.2.0/24 dev net2 proto kernel scope link src 169.30.2.2
169.254.1.1 dev eth0 scope link
192.168.117.0/24 nhid 18 proto static metric 20
	nexthop via 169.30.1.1 dev net1 weight 1
	nexthop via 169.30.2.1 dev net2 weight 1
root@lb-bgp-pod-node1-n3:/#

root@lb-bgp-pod-node1-n3:/# netstat -nr
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         169.254.1.1     0.0.0.0         UG        0 0          0 eth0
10.81.100.100   0.0.0.0         255.255.255.255 UH        0 0          0 lo
169.30.1.0      0.0.0.0         255.255.255.0   U         0 0          0 net1
169.30.2.0      0.0.0.0         255.255.255.0   U         0 0          0 net2
169.254.1.1     0.0.0.0         255.255.255.255 UH        0 0          0 eth0
192.168.117.0   169.30.1.1      255.255.255.0   UG        0 0          0 net1
root@lb-bgp-pod-node1-n3:/#

root@lb-bgp-pod-node1-n3:/# ping 192.168.117.2 -I 10.81.100.100
PING 192.168.117.2 (192.168.117.2) from 10.81.100.100 : 56(84) bytes of data.
64 bytes from 192.168.117.2: icmp_seq=1 ttl=61 time=0.074 ms
64 bytes from 192.168.117.2: icmp_seq=2 ttl=61 time=0.156 ms
^C
--- 192.168.117.2 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1062ms
rtt min/avg/max/mdev = 0.074/0.115/0.156/0.041 ms
root@lb-bgp-pod-node1-n3:/#

root@lb-bgp-pod-node1-n3:/# traceroute 192.168.117.2 --source=10.81.100.100
traceroute to 192.168.117.2 (192.168.117.2), 30 hops max, 60 byte packets
 1  * 169.30.1.1 (169.30.1.1)  0.499 ms  0.519 ms
 2  245.128.0.4 (245.128.0.4)  0.668 ms  0.757 ms  0.750 ms
 3  245.128.0.100 (245.128.0.100)  1.722 ms  1.920 ms *
 4  192.168.117.2 (192.168.117.2)  0.189 ms  0.183 ms  0.177 ms
root@lb-bgp-pod-node1-n3:/#

root@lb-bgp-pod-node1-n3:/# vtysh

Hello, this is FRRouting (version 10.1).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

lb-bgp-pod-node1-n3# sh ip route
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

K>* 0.0.0.0/0 [0/0] via 169.254.1.1, eth0, 1d04h14m
L * 10.0.59.225/32 is directly connected, eth0, 1d04h14m
C>* 10.0.59.225/32 is directly connected, eth0, 1d04h14m
K * 10.81.100.100/32 [0/0] is directly connected, lo, 1d03h26m
L * 10.81.100.100/32 is directly connected, lo, 1d03h27m
C>* 10.81.100.100/32 is directly connected, lo, 1d03h27m
C>* 169.30.1.0/24 is directly connected, net1, 1d04h14m
L>* 169.30.1.2/32 is directly connected, net1, 1d04h14m
C>* 169.30.2.0/24 is directly connected, net2, 1d04h14m
L>* 169.30.2.2/32 is directly connected, net2, 1d04h14m
K>* 169.254.1.1/32 [0/0] is directly connected, eth0, 1d04h14m
S>* 192.168.117.0/24 [1/0] via 169.30.1.1, net1, weight 1, 1d04h14m
  *                        via 169.30.2.1, net2, weight 1, 1d04h14m
lb-bgp-pod-node1-n3#

==============================================================================================
### N4 Routing Table
root@lb-bgp-pod-node1-n4:/# ip route
default via 169.254.1.1 dev eth0
10.81.100.101 dev lo scope link
169.30.5.0/24 dev net1 proto kernel scope link src 169.30.5.2
169.30.6.0/24 dev net2 proto kernel scope link src 169.30.6.2
169.254.1.1 dev eth0 scope link
192.168.17.0/24 nhid 45 proto static metric 20
	nexthop via 169.30.5.1 dev net1 weight 1
	nexthop via 169.30.6.1 dev net2 weight 1

root@lb-bgp-pod-node1-n4:/# netstat -nr
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         169.254.1.1     0.0.0.0         UG        0 0          0 eth0
10.81.100.101   0.0.0.0         255.255.255.255 UH        0 0          0 lo
169.30.5.0      0.0.0.0         255.255.255.0   U         0 0          0 net1
169.30.6.0      0.0.0.0         255.255.255.0   U         0 0          0 net2
169.254.1.1     0.0.0.0         255.255.255.255 UH        0 0          0 eth0
192.168.17.0    169.30.5.1      255.255.255.0   UG        0 0          0 net1

root@lb-bgp-pod-node1-n4:/# ping 192.168.17.2 -I 10.81.100.101
PING 192.168.17.2 (192.168.17.2) from 10.81.100.101 : 56(84) bytes of data.
64 bytes from 192.168.17.2: icmp_seq=1 ttl=61 time=0.093 ms
64 bytes from 192.168.17.2: icmp_seq=2 ttl=61 time=0.034 ms
64 bytes from 192.168.17.2: icmp_seq=3 ttl=61 time=0.099 ms
^C
--- 192.168.17.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2085ms
rtt min/avg/max/mdev = 0.034/0.075/0.099/0.029 ms
root@lb-bgp-pod-node1-n4:/#

root@lb-bgp-pod-node1-n4:/# vtysh

Hello, this is FRRouting (version 10.1).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

lb-bgp-pod-node1-n4# sh ip route
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

K>* 0.0.0.0/0 [0/0] via 169.254.1.1, eth0, 1d00h16m
L * 10.0.58.47/32 is directly connected, eth0, 1d00h16m
C>* 10.0.58.47/32 is directly connected, eth0, 1d00h16m
K * 10.81.100.101/32 [0/0] is directly connected, lo, 1d00h14m
L * 10.81.100.101/32 is directly connected, lo, 1d00h14m
C>* 10.81.100.101/32 is directly connected, lo, 1d00h14m
C>* 169.30.5.0/24 is directly connected, net1, 1d00h16m
L>* 169.30.5.2/32 is directly connected, net1, 1d00h16m
C>* 169.30.6.0/24 is directly connected, net2, 1d00h16m
L>* 169.30.6.2/32 is directly connected, net2, 1d00h16m
K>* 169.254.1.1/32 [0/0] is directly connected, eth0, 1d00h16m
S>* 192.168.17.0/24 [1/0] via 169.30.5.1, net1, weight 1, 1d00h16m
  *                       via 169.30.6.1, net2, weight 1, 1d00h16m
lb-bgp-pod-node1-n4#

==============================================================================================
### N6 Routing Table
root@lb-bgp-pod-node1-n6:/# ip route
default via 169.254.1.1 dev eth0
10.81.100.102 dev lo scope link
169.30.3.0/24 dev net1 proto kernel scope link src 169.30.3.2
169.30.4.0/24 dev net2 proto kernel scope link src 169.30.4.2
169.254.1.1 dev eth0 scope link
192.168.127.0/24 nhid 20 proto static metric 20
	nexthop via 169.30.3.1 dev net1 weight 1
	nexthop via 169.30.4.1 dev net2 weight 1

root@lb-bgp-pod-node1-n6:/# netstat -nr
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         169.254.1.1     0.0.0.0         UG        0 0          0 eth0
10.81.100.102   0.0.0.0         255.255.255.255 UH        0 0          0 lo
169.30.3.0      0.0.0.0         255.255.255.0   U         0 0          0 net1
169.30.4.0      0.0.0.0         255.255.255.0   U         0 0          0 net2
169.254.1.1     0.0.0.0         255.255.255.255 UH        0 0          0 eth0
192.168.127.0   169.30.3.1      255.255.255.0   UG        0 0          0 net1

root@lb-bgp-pod-node1-n6:/# ping 192.168.127.2 -I 10.81.100.102
PING 192.168.127.2 (192.168.127.2) from 10.81.100.102 : 56(84) bytes of data.
64 bytes from 192.168.127.2: icmp_seq=1 ttl=61 time=0.069 ms
64 bytes from 192.168.127.2: icmp_seq=2 ttl=61 time=0.064 ms
64 bytes from 192.168.127.2: icmp_seq=3 ttl=61 time=0.104 ms
^C
--- 192.168.127.2 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2058ms
rtt min/avg/max/mdev = 0.064/0.079/0.104/0.017 ms
root@lb-bgp-pod-node1-n6:/# 

root@lb-bgp-pod-node1-n6:/# traceroute 192.168.127.2 --source=10.81.100.102
traceroute to 192.168.127.2 (192.168.127.2), 30 hops max, 60 byte packets
 1  * 169.30.4.1 (169.30.4.1)  0.445 ms  0.489 ms
 2  245.128.0.90 (245.128.0.90)  0.612 ms  0.675 ms  0.668 ms
 3  245.128.0.138 (245.128.0.138)  1.561 ms  1.667 ms  42.597 ms
 4  192.168.127.2 (192.168.127.2)  0.064 ms  0.058 ms  0.051 ms
root@lb-bgp-pod-node1-n6:/#

root@lb-bgp-pod-node1-n6:/# vtysh

Hello, this is FRRouting (version 10.1).
Copyright 1996-2005 Kunihiro Ishiguro, et al.

lb-bgp-pod-node1-n6# sh ip route
Codes: K - kernel route, C - connected, L - local, S - static,
       R - RIP, O - OSPF, I - IS-IS, B - BGP, E - EIGRP, N - NHRP,
       T - Table, v - VNC, V - VNC-Direct, A - Babel, F - PBR,
       f - OpenFabric, t - Table-Direct,
       > - selected route, * - FIB route, q - queued, r - rejected, b - backup
       t - trapped, o - offload failure

K>* 0.0.0.0/0 [0/0] via 169.254.1.1, eth0, 1d00h24m
L * 10.0.58.233/32 is directly connected, eth0, 1d00h24m
C>* 10.0.58.233/32 is directly connected, eth0, 1d00h24m
K * 10.81.100.102/32 [0/0] is directly connected, lo, 1d00h24m
L * 10.81.100.102/32 is directly connected, lo, 1d00h24m
C>* 10.81.100.102/32 is directly connected, lo, 1d00h24m
C>* 169.30.3.0/24 is directly connected, net1, 1d00h24m
L>* 169.30.3.2/32 is directly connected, net1, 1d00h24m
C>* 169.30.4.0/24 is directly connected, net2, 1d00h24m
L>* 169.30.4.2/32 is directly connected, net2, 1d00h24m
K>* 169.254.1.1/32 [0/0] is directly connected, eth0, 1d00h24m
S>* 192.168.127.0/24 [1/0] via 169.30.3.1, net1, weight 1, 1d00h24m
  *                        via 169.30.4.1, net2, weight 1, 1d00h24m
lb-bgp-pod-node1-n6#