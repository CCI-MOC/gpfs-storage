export PATH="$PATH:/usr/lib64/mpich/bin"
mpiexec --hosts localhost -np 32 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i 1