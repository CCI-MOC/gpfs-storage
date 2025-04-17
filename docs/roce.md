### RoCE
To enable RoCE, the [Mellanox OFED driver](https://network.nvidia.com/products/infiniband-drivers/linux/mlnx_ofed/) must be installed.
See `roce.yaml` playbook for undocumented dependencies that need to be installed for successful execution of the installer.

After installation, we should already be ready to enable RDMA on the GPFS clients.

```bash
mmchconfig verbsRdma=enable
mmchconfig verbsRdmaCm=enable
mmchconfig verbsRdmaSend=yes
ibdev2netdev
mmchconfig verbsPorts="mlx5_5/1 mlx5_2/1"
# To have more ports quotes and spaces
# mmchconfig verbsPorts="mlx5_5/1 mlx5_4/1"
# Needs to have an ipv6 address set
# nmcli connection modify eno5np0 ipv6.method link-local (?)


# Restart
mmshutdown -a
mmstartup -a

# Verify logs in 
/var/adm/ras/mmfs.log.latest
```

### Removing RDMA
```bash
mmchconfig verbsRdma=disable
mmchconfig verbsRdmaCm=disable
mmchconfig verbsRdmaSend=no
ibdev2netdev
mmchconfig verbsPorts=NA

```

### Multiple Ports
When wanting to use multiple ports, the routing tables need to be modified so that each interface only responds to the appropriate IP addresses.

See section [3.4.7 Routing Configuration](https://redbooks.ibm.com/redpapers/pdfs/redp5658.pdf)

```bash
nmcli con mod eno7np0 +ipv4.routes "0.0.0.0/1 10.7.15.254 table=101, 128.0.0.0/1 10.7.15.254 table=101"
nmcli con mod eno7np0 +ipv4.routes "10.7.0.0/20  table=101 src=10.7.1.25"
nmcli con mod eno7np0 +ipv4.routing-rules "priority 32761 from 10.7.1.25 table 101"

nmcli con up eno6np0
nmcli con mod eno6np0 ipv4.never-default yes
nmcli con mod eno6np0 +ipv4.routes "0.0.0.0/1 10.7.15.254 table=102, 128.0.0.0/1 10.7.15.254 table=102"
nmcli con mod eno6np0 +ipv4.routes "10.7.0.0/20  table=102 src=10.7.10.12"
nmcli con mod eno6np0 +ipv4.routing-rules "priority 32761 from 10.7.10.12 table 102"
nmcli con down eno6np0
nmcli con up eno6np0

# 10.7.10.13
nmcli con up eno5np0
nmcli con mod eno5np0 ipv4.never-default yes
nmcli con mod eno5np0 +ipv4.routes "0.0.0.0/1 10.7.15.254 table=103, 128.0.0.0/1 10.7.15.254 table=103"
nmcli con mod eno5np0 +ipv4.routes "10.7.0.0/20  table=103 src=10.7.10.13"
nmcli con mod eno5np0 +ipv4.routing-rules "priority 32761 from 10.7.10.13 table 103"
nmcli con down eno5np0
nmcli con up eno5np0

mmchconfig verbsPorts="mlx5_5/1 mlx5_2/1 mlx5_3/1"

cat /var/adm/ras/mmfs.log.latest
```

You can use the `ib_mon.py` script in `playbooks/files/ib_mon.py` to monitor the RDMA packets from each interface.
