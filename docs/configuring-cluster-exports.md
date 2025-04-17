## Cluster Exports

### NFS Mount
```bash
# From EMS node
mmcrfileset essfs nfs_test1 --inode-space new
mmlinkfileset essfs nfs_test1 -J /gfs/essfs/nfs_test1

mmuserauth service create --data-access-method file --type userdefined
mmnfs export add /gpfs/essfs/nfs_test1
mmnfs export change /gpfs/essfs/nfs_test1 --nfschange "*(Access_Type=RW,Squash=NO_ROOT_SQUASH,SecType=sys,Protocols=3)"

# From user node
mount -t nfs 10.7.0.170:/gpfs/essfs/nfs_test1 /var/nfs_test1
```

### S3 Export
[Documentation](https://www.ibm.com/docs/en/storage-scale/5.2.1?topic=buckets-managing-s3-accounts)
