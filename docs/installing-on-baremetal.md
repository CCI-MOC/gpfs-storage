## Installing GPFS on Bare Metal

GPFS supports native client installation on bare metal systems.
The [supported operating systems](https://www.ibm.com/docs/en/STXKQY/gpfsclustersfaq.html#fsi) are RHEL 8 and RHEL 9 and the last 3 LTS releases of Ubuntu (20.04, 22.04 and 24.04.)

During this setup, we will be creating a new GPFS cluster and adding the filesystem of the remote cluster (ESS).

### Installation
The installation of GPFS on compute nodes is divided into two steps

- Installing the scale packages
- Installing the portability layer for the kernel

#### Scale Packages
An automated installer will extract the required packages into the system.

```bash
./Storage_Scale_data_management-5.2.2.1-x86_64-Linux-install --text-only
```

These files will be extracted to `/usr/lpp/mmfs`, whose `bin` needs to be added to `PATH` and `lib` needs to be added to `LD_LIBRARY_PATH`.

RPM packages are in `/usr/lpp/mmfs/5.2.2.1/gpfs_rpms`.
Install all, minus the `gui` and `afm` packages.

#### Portability Layer
The portability layer is the kernel connection to GPFS.
Building it compiles an RPM.
This process needs to be done every time there's a kernel update.

The `/usr/lpp/mmfs/bin/mmbuildgpl --build-package` command will provide helpful information about missing dependencies or issues and build the RPM package.

The portability layer package is built under
```
/root/rpmbuild/RPMS/x86_64/gpfs.gplbin-5.14.0-503.35.1.el9_5.x86_64-5.2.2-1.x86_64.rpm
```
Copy entire /usr/lpp directory to all nodes in the cluster.

```
rsync -r lpp gpfs-client-02:/usr/
```

#### Creating the cluster
We create a remote cluster with these 3 nodes and access the remote GPFS cluster from it.

The first node we set up will be the manager and quorum node.
In this cluster all 3 nodes will be part of the quorum.

Everytime a quorum node is changed, the cluster needs to be restarted. 

```bash 
mmcrcluster
Usage:
  mmcrcluster -N {NodeDesc[,NodeDesc...] | NodeFile}
     [ [-r RemoteShellCommand] [-R RemoteFileCopyCommand] |
       --use-sudo-wrapper [--sudo-user UserName] ]
     [-C ClusterName] [-U DomainName] [-A]
     [-c ConfigFile | --profile ProfileName] [--port PortNumber]

mmcrcluster -N <node1>:manager-quorum -r /usr/bin/ssh -R /usr/bin/scp -C <cluster_name>.local

# Quorum nodes need `server`, non quorum nodes can also be `client`.
mmchlicense server --accept -N <node1>
mmstartup -a

mmgetstate -a
```

After that we disable the firewall and then run to add the other 2 nodes.
Since we are changing quorum nodes, the cluster needs to be shutdown with `mmshutdown -a`.

```
mmaddnode -N <node2>,<node3>
mmchnode --manager --quorum -N <node2>,<node3>
```

#### Adding remote cluster filesystem to created cluster
After the cluster has been created, we can add the remote cluster filesystem to this cluster.

I will be referring to the GPFS servers storing the data as the remote cluster and the client GPFS nodes as the local cluster.

Authentication is done via public keys, with the public key of each node of the local cluster stored in
```bash
/var/mmfs/ssl/id_rsa.pub
```

The local cluster needs to be authorized from the remote cluster, to do this we copy the above key to the remote cluster and 

```bash
mmauth add <cluster_name>.local -k <public_key>
mmauth show
````

Changing the cluster name requires a new key and new authorization.

We also fetch the public key of the remote cluster.

In this example the remote cluster is named `test01.local`.

```bash
mmremotecluster add test01.local  -n ibm-ess6ka-hs.local,ibm-ess6kb-hs.local -k id_rsa.pub

mmremotefs add /dev/gpfs -f /dev/essfs -C test01.local -T /gpfs

mmmount gpfs -a
```

Need to designate a shared range of ports across the compute nodes and the server nodes
that doesn't conflict with other applications. 

```bash
mmchconfig tscCmdPortRange=<LowNumber>-<HighNumber>
```

### Configuring parameters for GPFS
```bash
mmchconfig maxblocksize=16M
mmchconfig autoload=yes
mmchconfig pagepool=16G
mmchconfig pagepool=80G
mmchconfig maxMBps=50000
mmchconfig maxFilesToCache=128k
mmchconfig maxStatCache=1M
```

### Removing a node from a cluster and creating a new cluster
```bash
mmchcluster -C <cluster_name>.local
mmauth genkey new
mmshutdown -a

```

### Restarting GPFS
After every restart of GPFS, must remount.
Make sure to not be in `/gpfs/` directory otherwhile it will silently fail.

```bash
mmshutdown -a
mmstartup -a
mmmount gpfs -a
```

### Creating a new fileset for the cluster
See [here](filesets.md)


### Configuring RoCE
See [here](roce.md)
