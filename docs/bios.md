# Setting BIOS Configs
https://github.com/CCI-MOC/ops-issues/issues/1522#issue-3064061495

Find ipmi ip of node using `sudo ipmitool lan print`


Defaults

```bash
export NODE=n26
```

```bash
nodeconfig $NODE Processors.DeterminismSlider=Performance
nodeconfig $NODE Processors.cTDP=Auto
nodeconfig $NODE Processors.PackagePowerLimit=Auto
nodeconfig $NODE Processors.4-LinkxGMIMaxSpeed=Minimum
nodeconfig $NODE Processors.GlobalC-stateControl=Enabled
nodeconfig $NODE Processors.P-state1=Enabled
nodeconfig $NODE Processors.CPUSpeculativeStoreModes=Balanced
nodeconfig $NODE Memory.MemorySpeed=Maximum
nodeconfig $NODE "OperatingModes.ChooseOperatingMode=Maximum Efficiency"
nodeconfig $NODE Power.EfficiencyMode=Enabled
```

Optimized
```bash
nodeconfig $NODE "OperatingModes.ChooseOperatingMode=Custom Mode"
nodeconfig $NODE Power.EfficiencyMode=Disabled
nodeconfig $NODE Processors.DeterminismSlider=Power
nodeconfig $NODE Processors.cTDP=Maximum
nodeconfig $NODE Processors.PackagePowerLimit=Maximum
nodeconfig $NODE Processors.4-LinkxGMIMaxSpeed=32Gbps
nodeconfig $NODE Processors.GlobalC-stateControl=Disabled
nodeconfig $NODE Processors.P-state1=Disabled
nodeconfig $NODE Memory.MemorySpeed=Maximum
nodeconfig $NODE "Processors.CPUSpeculativeStoreModes=More Speculative"

```

Check
```bash
nodeconfig $NODE |grep -E 'Processors.cTDP|Processors.DeterminismSlider|Processors.PackagePowerLimit|Processors.4-LinkxGMIMaxSpeed|Processors.GlobalC-stateControl|Processors.P-state1|Processors.CPUSpeculativeStoreModes|Memory.MemorySpeed|Power.EfficiencyMode'

```

```bash
nodeconfig n25 "BootOrder.BootOrder=Red Hat Enterprise Linux,Rocky Linux,Network,CD/DVD Rom,Hard Disk,USB Storage"
```
