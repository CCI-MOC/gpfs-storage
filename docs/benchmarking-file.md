### File-based Benchmarking

For file-based benchmarks we run IOR.
This benchmark can scale across several nodes by changing the `--hosts` parameter.

```
export PATH="$PATH:/usr/lib64/mpich/bin"
mpiexec --hosts gpfs-client-02 -np 4 /usr/local/bin/ior -a POSIX -b 8G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i 3
```
