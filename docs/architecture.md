### Architecture of GPFS Clients

For testing purposes, we are using 3 nodes with 4 H100 GPUs each.

![](docs/diagrams/baremetal-testing-1-diagram.png)

There are two mechanisms for accessing GPFS systems.

- [Installing the scale client software](installing-on-baremetal.md)
- [Accessing the storage from NFS or S3 exports](configuring-cluster-exports.md)

All nodes have the scale client software installed and are part of two clusters

`gpfs-client-01` and `02` in one cluster.
`gpfs-client-03` in a cluster by itself.
