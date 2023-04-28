# Copyright (C) 2022, Advanced Micro Devices, Inc.
# SPDX-License-Identifier: Apache-2.0

##################################################################
# DESIGN PROCs
##################################################################

# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports

  set ::PS_INST zynq_ultra_ps_e_0
  set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0 ] 
  
  apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} [get_bd_cells zynq_ultra_ps_e_0] 
  
  set_property -dict [ list \
  CONFIG.PSU_MIO_36_DRIVE_STRENGTH {4} \
  CONFIG.PSU__FPGA_PL0_ENABLE {1} \
  CONFIG.PSU__NUM_FABRIC_RESETS {1} \
  CONFIG.PSU__USE__IRQ0 {1} \
  CONFIG.PSU__USE__M_AXI_GP0  {0} \
  CONFIG.PSU__USE__M_AXI_GP1  {0} \
  CONFIG.PSU__USE__M_AXI_GP2  {0} \
  CONFIG.PSU__USE__S_AXI_ACE  {0} \
  CONFIG.PSU__USE__S_AXI_ACP  {0} \
  CONFIG.PSU__USE__S_AXI_GP0  {0} \
  CONFIG.PSU__USE__S_AXI_GP1  {0} \
  CONFIG.PSU__USE__S_AXI_GP2  {0} \
  CONFIG.PSU__USE__S_AXI_GP3  {0} \
  CONFIG.PSU__USE__S_AXI_GP4  {0} \
  CONFIG.PSU__USE__S_AXI_GP5  {0} \
  CONFIG.PSU__USE__S_AXI_GP6  {0} \
] [get_bd_cells zynq_ultra_ps_e_0] 


# Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""

