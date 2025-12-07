ip a a 100.100.100.100/32 dev eth0
ip -co -4 a s dev eth0
ip route add 100.100.100.0/32 dev eth0


ip a a 10.81.100.100/32 dev eth0
ip -co -4 a s dev eth0
ip route add 10.81.100.100/32 dev eth0

ip a d 10.81.100.100/32 dev eth0
ip -co -4 r s dev eth0
ip route del 10.81.100.100/32 dev eth0

ip a a 10.81.100.100/32 dev net1
ip -co -4 a s dev net1
ip route add 10.81.100.100/32 dev net1

ip a d 10.81.100.100/32 dev net1
ip -co -4 r s dev net1
ip route del 10.81.100.100/32 dev net1

ip a a 10.81.100.100/32 dev net2
ip -co -4 a s dev net2
ip route add 10.81.100.100/32 dev net2

ip a d 10.81.100.100/32 dev net2
ip -co -4 r s dev net2
ip route del 10.81.100.100/32 dev net2

## N3 loopback
ifconfig lo:0 10.81.100.100 netmask 255.255.255.255 up
ip -co -4 a s dev lo:0
ip route add 10.81.100.100/32 dev lo:0

## Viavi N3
root@lb-bgp-pod-node1:/# ip route add 192.168.117.0/24 via 169.30.2.1
root@lb-bgp-pod-node1:/# ping 192.168.117.1
PING 192.168.117.1 (192.168.117.1) 56(84) bytes of data.
64 bytes from 192.168.117.1: icmp_seq=1 ttl=62 time=5.47 ms


## lb-2
root@lb-bgp-pod-node2:/# ip route
default via 169.254.1.1 dev eth0
10.81.100.100 dev eth0 scope link
169.30.1.0/24 dev net1 proto kernel scope link src 169.30.1.3
169.30.2.0/24 dev net2 proto kernel scope link src 169.30.2.3
169.254.1.1 dev eth0 scope link
root@lb-bgp-pod-node2:/#

root@lb-bgp-pod-node2:/# ip route add 192.168.117.0/24 via 169.30.2.1

root@lb-bgp-pod-node2:/# ip route
default via 169.254.1.1 dev eth0
10.81.100.100 dev eth0 scope link
169.30.1.0/24 dev net1 proto kernel scope link src 169.30.1.3
169.30.2.0/24 dev net2 proto kernel scope link src 169.30.2.3
169.254.1.1 dev eth0 scope link
192.168.117.0/24 via 169.30.2.1 dev net2
root@lb-bgp-pod-node2:/#

# lb-1
root@lb-bgp-pod-node1:/# ip route
default via 169.254.1.1 dev eth0
10.81.100.100 dev eth0 scope link
169.30.1.0/24 dev net1 proto kernel scope link src 169.30.1.2
169.30.2.0/24 dev net2 proto kernel scope link src 169.30.2.2
169.254.1.1 dev eth0 scope link
192.168.117.0/24 via 169.30.2.1 dev net2
root@lb-bgp-pod-node1:/#


=======
viavi@r740-35c5lq3:~$ traceroute 10.81.100.100
traceroute to 10.81.100.100 (10.81.100.100), 30 hops max, 60 byte packets
 1  192.168.117.1 (192.168.117.1)  0.818 ms  0.830 ms *
 2  245.128.0.125 (245.128.0.125)  0.491 ms 245.128.0.113 (245.128.0.113)  0.428 ms 245.128.0.125 (245.128.0.125)  0.503 ms
 3  245.128.0.89 (245.128.0.89)  0.522 ms  0.541 ms 245.128.0.65 (245.128.0.65)  0.531 ms
 4  10.81.100.100 (10.81.100.100)  0.154 ms  0.144 ms  0.150 ms
viavi@r740-35c5lq3:~$

root@sjc38-4306> ...ce 192.168.117.1 routing-instance RAN_3403
PING 10.81.100.100 (10.81.100.100) from 192.168.117.1 : 56(84) bytes of data.
64 bytes from 10.81.100.100: icmp_seq=1 ttl=125 time=2.04 ms
64 bytes from 10.81.100.100: icmp_seq=2 ttl=125 time=0.582 ms
64 bytes from 10.81.100.100: icmp_seq=3 ttl=125 time=0.573 ms
^C
--- 10.81.100.100 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2037ms
rtt min/avg/max/mdev = 0.573/1.065/2.040/0.689 ms

root@sjc38-4306>



===

ip a a 10.81.100.101/32 dev net2
ip -co -4 a s dev net2
ip route add 10.81.100.101/32 dev net2

=============================================================

## N3 loopback
ifconfig lo:0 10.81.100.100 netmask 255.255.255.255 up
ip -co -4 a s dev lo:0
ip route add 10.81.100.100/32 dev lo:0

## N4 loopback
ifconfig lo:0 10.81.100.101 netmask 255.255.255.255 up
ip -co -4 a s dev lo:0
ip route add 10.81.100.101/32 dev lo:0

## N6 loopback
ifconfig lo:0 10.81.100.102 netmask 255.255.255.255 up
ip -co -4 a s dev lo:0
ip route add 10.81.100.102/32 dev lo:0