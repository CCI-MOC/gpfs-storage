set -xe

export PATH="$PATH:/usr/lib64/mpich/bin"

FILE="/gpfs/remote_test02/test_ior"
ITERATIONS=10

echo "------------ 1 NICS --------------"
./apply_setting_and_restart.sh "mlx5_5/1"
mpiexec --hosts gpfs-client-03,gpfs-client-02 -np 64 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS
mpiexec --hosts gpfs-client-01,gpfs-client-03,gpfs-client-02 -np 96 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS

echo "------------ 2 NICS --------------"
./apply_setting_and_restart.sh "mlx5_5/1 mlx5_4/1"
mpiexec --hosts gpfs-client-03,gpfs-client-02 -np 64 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS
mpiexec --hosts gpfs-client-01,gpfs-client-03,gpfs-client-02 -np 96 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS

echo "------------ 3 NICS --------------"
./apply_setting_and_restart.sh "mlx5_5/1 mlx5_4/1 mlx5_3/1"
mpiexec --hosts gpfs-client-03,gpfs-client-02 -np 64 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS
mpiexec --hosts gpfs-client-01,gpfs-client-03,gpfs-client-02 -np 96 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS

echo "------------ 4 NICS --------------"
./apply_setting_and_restart.sh "mlx5_5/1 mlx5_4/1 mlx5_3/1 mlx5_2/1"
mpiexec --hosts gpfs-client-03,gpfs-client-02 -np 64 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS
mpiexec --hosts gpfs-client-01,gpfs-client-03,gpfs-client-02 -np 96 /usr/local/bin/ior -a POSIX -b 24G -t 16M -o /gpfs/remote_test02/test_ior -w -r -C -F -i $ITERATIONS