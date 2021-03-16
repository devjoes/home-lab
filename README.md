# home-lab
### K8S cluster and supporting infrastructure.

This will create some 3 VMs on a Proxmox server and deploy a 1 master and 2 worker nodes cluster using kubespray.
The cluster exists on VNET 99 in Proxmox in the 10.99.0.0/16 range. You will have to add a route to it.
It comes with MetalDB which allocates IPs to any LoadBalancers that are created.
If you have something like a RaspberryPi running isc-DHCP and PowerDNS (or just PowerDNS) then you can set the powerdns_server and powerdns_api_key variables. This will cause external-dns to also be deployed and create A records for any hosts that are exposed.

**This is just for me to use at home. If you put this anywhere near a production system then your going to have a bad time. Parts are held together with gaffa tape and it's about as HA as jelly. I am not responsible if your try to run a hospital or something on it and things go badly wrong!**

It requires a Proxmox environment with networking set up like this:

```
# /etc/network/interfaces
auto lo
iface lo inet loopback

iface enp3s0 inet manual

auto vmbr0
iface vmbr0 inet static
        address 192.168.0.200/24
        gateway 192.168.0.1
        bridge-ports enp3s0
        bridge-stp off
        bridge-fd 0
        bridge-vlan-aware yes
        bridge-vids 2-4094

auto vmbr0.99
iface vmbr0.99 inet static
        address 10.99.0.1/16
        vlan-id 99
```

```
# /etc/network/if-up.d/routing
#!/bin/sh
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -i vmbr0.99 -o vmbr0 -j ACCEPT
iptables -A FORWARD -i vmbr0 -o vmbr0.99 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o vmbr0 -j MASQUERADE
```

After deploying then this command will set up your kubeconfig
```
cp "$HOME/.kube/config" "$HOME/.kube/config.$(date +%s)"
sed -i 's/127\.0\.0\.1/10.99.0.10/' ./.terraform/tmp/config
KUBECONFIG="$HOME/.kube/config:./.terraform/tmp/config" kubectl config view --flatten > $HOME/.kube/config"
```