Kria SOM Base HW Projects

To generate an XSA for starter kits

cd to <part_name>_starter_kits/<starter_kit_name>
Run command make xsa
Note you can also pass arguments to the make command make xsa JOBS= PROJ_NAME=<proj_name>
To generate an XSA for starter kit SOM

cd to <part_name>_starter_kits/base
Run command make xsa
Note you can also pass arguments to the make command make xsa JOBS= PROJ_NAME=<proj_name> Base design - Has fan control in PL part Base_gpio_bram design - Has a AXI GPIO and BRAM controller in PL part
To generate an XSA for a Production SOM

cd to kria_som/<som_name>
Run command make xsa
Note you can also pass arguments to the make command make xsa JOBS= PROJ_NAME=<proj_name>

# License

Copyright (C) 2022, Xilinx, Inc.
Copyright (C) 2022-2023, Advanced Micro Devices, Inc.
SPDX-License-Identifier: Apache-2.0
