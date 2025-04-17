export TARGET_PATH="/gpfs/remote_test02/fio_target"
mkdir -p $TARGET_PATH

export BENCHMARKS="fio"
export FIO_CAPACITY_MB="100000"
export FIO_RUNTIME="60" # in seconds
export ITERATIONS="4"
./fs-performance-container/entry.sh
