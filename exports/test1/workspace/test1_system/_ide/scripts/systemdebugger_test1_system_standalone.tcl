# Usage with Vitis IDE:
# In Vitis IDE create a Single Application Debug launch configuration,
# change the debug type to 'Attach to running target' and provide this 
# tcl script in 'Execute Script' option.
# Path of this script: C:\EEE3313_projects\final_project\exports\test1\workspace\test1_system\_ide\scripts\systemdebugger_test1_system_standalone.tcl
# 
# 
# Usage with xsct:
# To debug using xsct, launch xsct and run below command
# source C:\EEE3313_projects\final_project\exports\test1\workspace\test1_system\_ide\scripts\systemdebugger_test1_system_standalone.tcl
# 
connect -url tcp:127.0.0.1:3121
targets -set -nocase -filter {name =~"APU*"}
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Xilinx TUL 1234-tulA" && level==0 && jtag_device_ctx=="jsn-TUL-1234-tulA-23727093-0"}
fpga -file C:/EEE3313_projects/final_project/exports/test1/workspace/test1/_ide/bitstream/HDMI_TOP.bit
targets -set -nocase -filter {name =~"APU*"}
loadhw -hw C:/EEE3313_projects/final_project/exports/test1/workspace/HDMI_TOP/export/HDMI_TOP/hw/HDMI_TOP.xsa -mem-ranges [list {0x40000000 0xbfffffff}] -regs
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*"}
source C:/EEE3313_projects/final_project/exports/test1/workspace/test1/_ide/psinit/ps7_init.tcl
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "*A9*#0"}
dow C:/EEE3313_projects/final_project/exports/test1/workspace/test1/Debug/test1.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "*A9*#0"}
con
