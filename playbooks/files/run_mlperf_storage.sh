export PATH="$PATH:/usr/lib64/mpich/bin"

./benchmark.sh datagen \
    --hosts localhost \
    --workload unet3d \
    --accelerator-type h100 \
    --num-parallel 8 \
    --results-dir ../results \
    --param dataset.num_files_train=1000 \
    --param dataset.data_folder=/gpfs/remote_test02/unet3d_data_1

./benchmark.sh run \
    --hosts localhost \
    --workload unet3d \
    --accelerator-type h100 \
    --num-accelerators 4 \
    --results-dir ../results_a100/run1 \
    --param dataset.num_files_train=1000 \
    --param dataset.data_folder=/gpfs/remote_test02/unet3d_data_1
