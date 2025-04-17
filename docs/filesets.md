### Creating a new fileset for the cluster

Filesets are the unit by which we're going to be sharing access to GPFS.

We can grant access from a remote cluster to a fileset.

```bash
mmcrfileset <filesystem> <fileset_name> --inode-space new
mmlinkfileset <filessytem> <fileset_name> -J /gpfs/essfs/<fileset_name>
mmauth grant <cluster_name>.local -f <filesystem> --fileset root -a rw
mmauth grant <cluster_name>.local -f <filesystem> --fileset <fileset_name> -a rw
```

In the current GPFS PoC we have 2 filesets `remote_test01` and `remote_test02`.
