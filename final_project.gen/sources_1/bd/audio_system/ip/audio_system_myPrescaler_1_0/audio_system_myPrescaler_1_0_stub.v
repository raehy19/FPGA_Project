// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Mon Jun 19 17:59:14 2023
// Host        : RAEHYEON-AERO15 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/EEE3313_projects/final_project/final_project.gen/sources_1/bd/audio_system/ip/audio_system_myPrescaler_1_0/audio_system_myPrescaler_1_0_stub.v
// Design      : audio_system_myPrescaler_1_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "myPrescaler,Vivado 2020.2" *)
module audio_system_myPrescaler_1_0(clk, prescale)
/* synthesis syn_black_box black_box_pad_pin="clk,prescale" */;
  input clk;
  output prescale;
endmodule
