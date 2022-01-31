proc create_k26_base_starter_kit { parentCell nameHier } {

set parentObj [get_bd_cells $parentCell]

set oldCurInst [current_bd_instance .]

current_bd_instance $parentObj

if {$nameHier ne "" } {

set hier_obj [create_bd_cell -type hier $nameHier]

current_bd_instance $hier_obj

}
set ::PS_INST zynq_ultra_ps_e_0
set zynq_ultra_ps_e_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:zynq_ultra_ps_e zynq_ultra_ps_e_0 ] 

apply_bd_automation -rule xilinx.com:bd_rule:zynq_ultra_ps_e -config {apply_board_preset "1"} [get_bd_cells zynq_ultra_ps_e_0] 

set_property -dict [ list \
CONFIG.PSU__CRF_APB__DPLL_FRAC_CFG__ENABLED  {1} \
CONFIG.PSU__CRF_APB__VPLL_FRAC_CFG__ENABLED  {1} \
CONFIG.PSU__CRL_APB__USB3__ENABLE {1} \
CONFIG.PSU__FPGA_PL0_ENABLE {1} \
CONFIG.PSU__GPIO1_MIO__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__NUM_FABRIC_RESETS {4} \
CONFIG.PSU__SD0__PERIPHERAL__ENABLE {0} \
CONFIG.PSU__SWDT0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__SWDT1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC0__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC0__PERIPHERAL__IO {NA } \
CONFIG.PSU__TTC1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC1__PERIPHERAL__IO {NA } \
CONFIG.PSU__TTC2__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC2__PERIPHERAL__IO {NA } \
CONFIG.PSU__TTC3__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__TTC3__PERIPHERAL__IO {NA } \
CONFIG.PSU__UART1__BAUD_RATE {115200} \
CONFIG.PSU__UART1__PERIPHERAL__ENABLE {1} \
CONFIG.PSU__UART1__PERIPHERAL__IO {MIO 36 .. 37} \
CONFIG.PSU__DPAUX__PERIPHERAL__IO {MIO 27 .. 30} \
CONFIG.PSU__DP__LANE_SEL {None} \
CONFIG.PSU__DISPLAYPORT__PERIPHERAL__ENABLE {1} \
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



current_bd_instance $oldCurInst

}
create_k26_base_starter_kit "" ""

