### Experiments on OpenShift

- OpenShift Console https://console-openshift-console.apps.dublin.test.nerc.mghpcc.org/k8s/cluster/projects/cnsa-benchmark

#### Worker nodes
- `MOC-R4PCC02U17` -> `wrk-4`
- `MOC-R4PCC02U18` -> `wrk-5`
- `MOC-R4PCC02U36` -> `wrk-6`

#### Running the Experiments
The folders within this folder contain `job.yaml` files.

To run these experiments, after applying the manifest it is necessary to open a terminal into the
launcher pod that the MPI operator created (name includes launcher) and run the mpirun command
specified in the YAML file comments manually.

##### Notes

- These experiments use the `cnsa-benchmark` project.
- These experiments run via the MPI operator, which creates two kinds of pods. One launcher and several workers, based on the `replicas` field under `Workers` in the `MPIJob` specification.
- Node(s) to run on is specified via `nodeName` or `nodeSelector`. `nodeSelector` for IBM nodes can be done based on `quorum` designation of the nodes. See `mpi_ior_wrk456/job.yaml` for example.
- Because the pods use a specific UID via `runAsUser` and the IBM Spectrum Scale Operator does not allow specifying a specific UID for the PVC, it is necessary to `chown` the directory by using a debug pod with `--as-root`. The PVC that were created for these experiments, had `mkdir /target/test_ior` and `chown -R 1001110000:1001110000 /target/test_ior` performed on them.
- For some unkown reason, the MPI Job is unable to start the command by itself, but will patiently wait. So open a terminal inside the launcher pod and run the command specified in the command in the yaml manually to execute the experiment. 
- The `-np` parameter of the command should match or be less than the worker replicas specified in the YAML. A good number is 32 per each of the nodes that we want to test. So single node with all replicas running in the same node via nodeName gets 32.  For three node test 32 * 3 = 96. 