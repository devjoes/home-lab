# home-lab
K8S cluster and supporting infrastructure

**This is just for me to use at home. If you put this anywhere near a production system then your going to have a really bad day. Parts are held together with gaffa tape and it's about as HA as jelly.**

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
KUBECONFIG="$HOME/.kube/config:./.terraform/tmp/config" kubectl config view --flatten > $HOME/.kube/config"
```