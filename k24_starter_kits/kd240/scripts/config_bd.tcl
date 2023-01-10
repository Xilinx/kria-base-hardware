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
  set fan_en_b [ create_bd_port -dir O -from 0 -to 0 fan_en_b ]

  # Create instance: xlslice_0, and set properties
  set xlslice_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice xlslice_0 ]
  set_property -dict [ list \
   CONFIG.DIN_FROM {2} \
   CONFIG.DIN_TO {2} \
   CONFIG.DIN_WIDTH {3} \
   CONFIG.DOUT_WIDTH {1} \
 ] $xlslice_0
 
set ::PS_INST zynq_ultra_ps_e_0
set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0 ] 

 apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} [get_bd_cells zynq_ultra_ps_e_0] 

set_property -dict [ list \
  CONFIG.PSU__FPGA_PL0_ENABLE {1} \
  CONFIG.PSU__NUM_FABRIC_RESETS {1} \
  CONFIG.PSU__TTC0__WAVEOUT__ENABLE {1} \
  CONFIG.PSU__TTC0__WAVEOUT__IO {EMIO} \
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
  CONFIG.PSU__GPIO2_MIO__PERIPHERAL__ENABLE {1} \
  CONFIG.PSU_MIO_45_PULLUPDOWN {disable} \
  CONFIG.PSU_MIO_46_PULLUPDOWN {disable} \
  CONFIG.PSU_MIO_47_PULLUPDOWN {disable} \
  CONFIG.PSU_MIO_48_PULLUPDOWN {disable} \
] [get_bd_cells zynq_ultra_ps_e_0] 

# Create port connections
  connect_bd_net -net xlslice_0_Dout [get_bd_ports fan_en_b] [get_bd_pins xlslice_0/Dout]
  connect_bd_net -net zynq_ultra_ps_e_0_emio_ttc0_wave_o [get_bd_pins xlslice_0/Din] [get_bd_pins zynq_ultra_ps_e_0/emio_ttc0_wave_o]

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

