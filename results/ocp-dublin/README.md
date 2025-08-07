### Experiments on OpenShift

- OpenShift Console https://console-openshift-console.apps.dublin.test.nerc.mghpcc.org/k8s/cluster/projects/cnsa-benchmark

#### Worker nodes
- `MOC-R4PCC02U17` -> `wrk-4`
- `MOC-R4PCC02U18` -> `wrk-5`
- `MOC-R4PCC02U36` -> `wrk-6`

! To run MPI Jobs, after applying the manifest it is necessary to open a terminal into the
launcher pod that the MPI operator created (name includes launcher) and run the mpirun command
specified in the YAML file comments manually. 