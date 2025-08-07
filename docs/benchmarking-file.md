### File-based Benchmarking

For file-based benchmarks we run IOR.
This benchmark can scale across several nodes by changing the `--hosts` parameter.

```
export PATH="$PATH:/usr/lib64/mpich/bin"
mpiexec --hosts localhost -np 32 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i 3
```

To automatically perform testing over a variable number of interfaces look at the `apply_setting_and_restart.sh` and `variable_nic_benchmarks.sh` scripts.
