### Creating a node group

```bash
mmcrnodeclass gpfs_client_02 -N gpfs-client-02
```

```bash
mmchconfig workerThreads=1024 -N gpfs_servers
mmchconfig ignorePrefetchLUNCount=yes -N gpfs_servers
mmchconfig maxMBpS=80000 -N gpfs_servers
mmchconfig nsdRAIDClientOnlyChecksum=yes -N gpfs_servers
mmchconfig maxFilesToCache=128k -N gpfs_servers
mmchconfig maxStatCache=128k -N gpfs_servers
mmchconfig pagepool=32G -N gpfs_servers
mmchconfig numaMemoryInterleave=yes -N gpfs_servers
```
