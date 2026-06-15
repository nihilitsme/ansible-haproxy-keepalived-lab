# Node Controller
IP: 10.0.2.14/24
SSH Port : 22777

#Node Haproxy01
Host: lb01
IP:
ether1: 10.0.2.40/24
ether2: 192.168.100.100
SSH:22888


#Node Haproxy02
Host: lb02
IP:
ether1: 10.0.2.41/24
ether2: 192.168.100.200
SSH:22888


#Node 01
Host: Web01
IP:
ether1: 10.0.2.50/24
ether2: 192.168.100.101
SSH: 22888

#Node 02
Host: Web02
IP:
ether1: 10.0.2.60/24
ether2: 192.168.100.102
SSH:22888

#Node 03
Host: Web03
IP:
ether1: 10.0.2.70/24
ether2: 192.168.100.103
SSH:22888

#Node 04
Host: Web04
IP:
ether1: 10.0.2.80/24
ether2: 192.168.100.104
SSH:22888

#Node 05
Host: Web06
IP:
ether1: 10.0.2.90/24
ether2: 192.168.100.105
SSH:22888

#Node 07
Host: Web07
IP:
ether1: 10.0.2.91/24
ether2: 192.168.100.106
SSH:22888

#Node 08
Host: Web08
IP:
ether1: 10.0.2.92/24
ether2: 192.168.100.107
SSH:22888

## Virtual-IP LoadBalancer
192.168.100.123 on eth1 lb01 dan lb02

Network: 10.0.2.0/24,192.168.100.0/24
Host Only:192.168.100.0/24
NAT: 10.0.2.0/24
