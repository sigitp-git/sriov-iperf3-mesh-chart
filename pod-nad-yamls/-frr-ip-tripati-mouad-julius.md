FRR BGP AS 64765
TOR BGP AS 64764

FRR - N3/RAN VRF
======================================
VLAN1001 IRB: 169.30.1.1
VLAN1002 IRB: 169.30.2.1
FRR pod-1 net1 169.30.1.2 (VLAN 1001)
FRR pod-1 net2 169.30.2.2 (VLAN 1002)
FRR pod-2 net1 169.30.1.3 (VLAN 1001)
FRR pod-2 net2 169.30.2.3 (VLAN 1002)

pod-1:
ifconfig net1 169.30.1.2/24
ifconfig net2 169.30.2.2/24

pod-2:
ifconfig net1 169.30.1.3/24
ifconfig net2 169.30.2.3/24

iperf-c:
iperf3 -c 192.168.117.2 -p 5201 -t 0
root@lb-bgp-pod-node1-n3:/# iperf3 -c 192.168.117.2 -p 5202 -t 0
iperf3: error - unable to send control message: Bad file descriptor ==> server is not running

iperf-c 4 processes:
iperf3 -c 192.168.117.2 -p 5201 -t 0 &
iperf3 -c 192.168.117.2 -p 5202 -t 0 &
iperf3 -c 192.168.117.2 -p 5203 -t 0 &
iperf3 -c 192.168.117.2 -p 5204 -t 0 &

FRR - N4/CUPS VRF
======================================
VLAN3001 IRB: 169.30.5.1
VLAN3002 IRB: 169.30.6.1
FRR pod-1 net1 169.30.5.2 (VLAN 3001)
FRR pod-1 net2 169.30.6.2 (VLAN 3002)
FRR pod-2 net1 169.30.5.3 (VLAN 3001)
FRR pod-2 net2 169.30.6.3 (VLAN 3002)

pod-1:
ifconfig net1 169.30.5.2/24
ifconfig net2 169.30.6.2/24

pod-2:
ifconfig net1 169.30.5.3/24
ifconfig net2 169.30.6.3/24

FRR - N6/Internet VRF
======================================
VLAN2001 IRB: 169.30.3.1
VLAN2002 IRB: 169.30.4.1
FRR pod-1 net1 169.30.3.2 (VLAN 2001)
FRR pod-1 net2 169.30.4.2 (VLAN 2002)
FRR pod-2 net1 169.30.3.3 (VLAN 2001)
FRR pod-2 net2 169.30.4.3 (VLAN 2002)

pod-1:
ifconfig net1 169.30.3.2/24
ifconfig net2 169.30.4.2/24

pod-2:
ifconfig net1 169.30.3.3/24
ifconfig net2 169.30.4.3/24




=============================================================

## N3 loopback
ifconfig lo:0 10.81.100.100 netmask 255.255.255.255 up
[or] ip a a 10.81.100.100/32 dev lo:0
ip -co -4 a s dev lo:0
ip route add 10.81.100.100/32 dev lo:0

iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5201 -t 0 -u -b 1G --logfile iperf1.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5202 -t 0 -u -b 1G --logfile iperf2.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5203 -t 0 -u -b 1G --logfile iperf3.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5204 -t 0 -u -b 1G --logfile iperf4.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5205 -t 0 -u -b 1G --logfile iperf5.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5206 -t 0 -u -b 1G --logfile iperf6.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5207 -t 0 -u -b 1G --logfile iperf7.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5208 -t 0 -u -b 1G --logfile iperf8.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5209 -t 0 -u -b 1G --logfile iperf9.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5210 -t 0 -u -b 1G --logfile iperf10.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5211 -t 0 -u -b 1G --logfile iperf11.log &
iperf3 -c 192.168.117.2 -B 10.81.100.100 -p 5212 -t 0 -u -b 1G --logfile iperf12.log &

for pid in $(ps -ef | awk '/iperf3/ {print $2}'); do kill -9 $pid; done

multitail -i iperf1.log iperf2.log iperf3.log iperf4.log iperf5.log iperf6.log iperf7.log iperf8.log iperf9.log iperf10.log iperf11.log iperf12.log -ts

## N4 loopback
ifconfig lo:0 10.81.100.101 netmask 255.255.255.255 up
[or] ip a a 10.81.100.101/32 dev lo:0
ip -co -4 a s dev lo:0
ip route add 10.81.100.101/32 dev lo:0

iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5401 -t 0 -u -b 1G --logfile iperf1.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5402 -t 0 -u -b 1G --logfile iperf2.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5403 -t 0 -u -b 1G --logfile iperf3.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5404 -t 0 -u -b 1G --logfile iperf4.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5405 -t 0 -u -b 1G --logfile iperf5.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5406 -t 0 -u -b 1G --logfile iperf6.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5407 -t 0 -u -b 1G --logfile iperf7.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5408 -t 0 -u -b 1G --logfile iperf8.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5409 -t 0 -u -b 1G --logfile iperf9.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5410 -t 0 -u -b 1G --logfile iperf10.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5411 -t 0 -u -b 1G --logfile iperf11.log &
iperf3 -c 192.168.17.2 -B 10.81.100.101 -p 5412 -t 0 -u -b 1G --logfile iperf12.log &

for pid in $(ps -ef | awk '/iperf3/ {print $2}'); do kill -9 $pid; done

multitail -i iperf1.log iperf2.log iperf3.log iperf4.log iperf5.log iperf6.log iperf7.log iperf8.log iperf9.log iperf10.log iperf11.log iperf12.log -ts

## N6 loopback
ifconfig lo:0 10.81.100.102 netmask 255.255.255.255 up
[or] ip a a 10.81.100.102/32 dev lo:0
ip -co -4 a s dev lo:0
ip route add 10.81.100.102/32 dev lo:0

iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5301 -t 0 -u -b 1G --logfile iperf1.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5302 -t 0 -u -b 1G --logfile iperf2.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5303 -t 0 -u -b 1G --logfile iperf3.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5304 -t 0 -u -b 1G --logfile iperf4.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5305 -t 0 -u -b 1G --logfile iperf5.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5306 -t 0 -u -b 1G --logfile iperf6.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5307 -t 0 -u -b 1G --logfile iperf7.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5308 -t 0 -u -b 1G --logfile iperf8.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5309 -t 0 -u -b 1G --logfile iperf9.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5310 -t 0 -u -b 1G --logfile iperf10.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5311 -t 0 -u -b 1G --logfile iperf11.log &
iperf3 -c 192.168.127.2 -B 10.81.100.102 -p 5312 -t 0 -u -b 1G --logfile iperf12.log &

for pid in $(ps -ef | awk '/iperf3/ {print $2}'); do kill -9 $pid; done

multitail -i iperf1.log iperf2.log iperf3.log iperf4.log iperf5.log iperf6.log iperf7.log iperf8.log iperf9.log iperf10.log iperf11.log iperf12.log -ts

=================================
Linux Multipath vs FRR Multipath
=================================

Linux Multipath:

## N3 Multipath
default:
ip route replace default proto static scope global \
    nexthop dev net1 via 169.30.1.1 weight 1 \
    nexthop dev net2 via 169.30.2.1 weight 1

specific:
ip route replace 192.168.117.0/24 proto static scope global \
    nexthop dev net1 via 169.30.1.1 weight 1 \
    nexthop dev net2 via 169.30.2.1 weight 1

before:
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

after:
root@lb-bgp-pod-node1-n3:/# ip route
default proto static
	nexthop via 169.30.1.1 dev net1 weight 1
	nexthop via 169.30.2.1 dev net2 weight 1
10.81.100.100 dev lo scope link
169.30.1.0/24 dev net1 proto kernel scope link src 169.30.1.2
169.30.2.0/24 dev net2 proto kernel scope link src 169.30.2.2
169.254.1.1 dev eth0 scope link
root@lb-bgp-pod-node1-n3:/#

root@lb-bgp-pod-node1-n3:/# netstat -nr
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         169.30.1.1      0.0.0.0         UG        0 0          0 net1
10.81.100.100   0.0.0.0         255.255.255.255 UH        0 0          0 lo
169.30.1.0      0.0.0.0         255.255.255.0   U         0 0          0 net1
169.30.2.0      0.0.0.0         255.255.255.0   U         0 0          0 net2
169.254.1.1     0.0.0.0         255.255.255.255 UH        0 0          0 eth0
root@lb-bgp-pod-node1-n3:/#

## N4 Multipath
default:
ip route replace default proto static scope global \
    nexthop dev net1 via 169.30.5.1 weight 1 \
    nexthop dev net2 via 169.30.6.1 weight 1

specific:
ip route replace 192.168.17.0/24 proto static scope global \
    nexthop dev net1 via 169.30.5.1 weight 1 \
    nexthop dev net2 via 169.30.6.1 weight 1

before:
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

after:
root@lb-bgp-pod-node1-n4:/# ip route
default proto static
	nexthop via 169.30.5.1 dev net1 weight 1
	nexthop via 169.30.6.1 dev net2 weight 1
10.81.100.101 dev lo scope link
169.30.5.0/24 dev net1 proto kernel scope link src 169.30.5.2
169.30.6.0/24 dev net2 proto kernel scope link src 169.30.6.2
169.254.1.1 dev eth0 scope link
root@lb-bgp-pod-node1-n4:/#

root@lb-bgp-pod-node1-n4:/# netstat -nr
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         169.30.5.1      0.0.0.0         UG        0 0          0 net1
10.81.100.101   0.0.0.0         255.255.255.255 UH        0 0          0 lo
169.30.5.0      0.0.0.0         255.255.255.0   U         0 0          0 net1
169.30.6.0      0.0.0.0         255.255.255.0   U         0 0          0 net2
169.254.1.1     0.0.0.0         255.255.255.255 UH        0 0          0 eth0
root@lb-bgp-pod-node1-n4:/#

## N6 Multipath
default:
ip route replace default proto static scope global \
    nexthop dev net1 via 169.30.3.1 weight 1 \
    nexthop dev net2 via 169.30.4.1 weight 1

specific:
ip route replace 192.168.127.0/24 proto static scope global \
    nexthop dev net1 via 169.30.3.1 weight 1 \
    nexthop dev net2 via 169.30.4.1 weight 1

before:
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

after:
root@lb-bgp-pod-node1-n6:/# ip route
default proto static
	nexthop via 169.30.3.1 dev net1 weight 1
	nexthop via 169.30.4.1 dev net2 weight 1
10.81.100.102 dev lo scope link
169.30.3.0/24 dev net1 proto kernel scope link src 169.30.3.2
169.30.4.0/24 dev net2 proto kernel scope link src 169.30.4.2
169.254.1.1 dev eth0 scope link
root@lb-bgp-pod-node1-n6:/#


root@lb-bgp-pod-node1-n6:/# netstat -nr
Kernel IP routing table
Destination     Gateway         Genmask         Flags   MSS Window  irtt Iface
0.0.0.0         169.30.3.1      0.0.0.0         UG        0 0          0 net1
10.81.100.102   0.0.0.0         255.255.255.255 UH        0 0          0 lo
169.30.3.0      0.0.0.0         255.255.255.0   U         0 0          0 net1
169.30.4.0      0.0.0.0         255.255.255.0   U         0 0          0 net2
169.254.1.1     0.0.0.0         255.255.255.255 UH        0 0          0 eth0
root@lb-bgp-pod-node1-n6:/#


==================================
REVERTING
==================================

## N3
root@lb-bgp-pod-node1-n3:/# ip route del default
root@lb-bgp-pod-node1-n3:/# ip route add default via 169.254.1.1 dev eth0
root@lb-bgp-pod-node1-n3:/#



================================
BFD
================================

bfd
 peer <neighbor_ip>
  detect-multiplier <value>
  receive-interval <milliseconds>
  transmit-interval <milliseconds>
 !
!