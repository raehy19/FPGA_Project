// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon Jun 19 17:59:13 2023
// Host        : RAEHYEON-AERO15 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/EEE3313_projects/final_project/final_project.gen/sources_1/bd/audio_system/ip/audio_system_myI2STx_v1_0_0_0/audio_system_myI2STx_v1_0_0_0_stub.v
// Design      : audio_system_myI2STx_v1_0_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "myI2STx_v1_0,Vivado 2020.2" *)
module audio_system_myI2STx_v1_0_0_0(mclk, bclk, lrclk, sdata, s00_axis_aclk, 
  s00_axis_aresetn, s00_axis_tready, s00_axis_tdata, s00_axis_tstrb, s00_axis_tlast, 
  s00_axis_tvalid)
/* synthesis syn_black_box black_box_pad_pin="mclk,bclk,lrclk,sdata,s00_axis_aclk,s00_axis_aresetn,s00_axis_tready,s00_axis_tdata[31:0],s00_axis_tstrb[3:0],s00_axis_tlast,s00_axis_tvalid" */;
  input mclk;
  output bclk;
  output lrclk;
  output sdata;
  input s00_axis_aclk;
  input s00_axis_aresetn;
  output s00_axis_tready;
  input [31:0]s00_axis_tdata;
  input [3:0]s00_axis_tstrb;
  input s00_axis_tlast;
  input s00_axis_tvalid;
endmodule
