-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Mon Jun 19 17:59:14 2023
-- Host        : RAEHYEON-AERO15 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               c:/EEE3313_projects/final_project/final_project.gen/sources_1/bd/audio_system/ip/audio_system_myPrescaler_1_0/audio_system_myPrescaler_1_0_stub.vhdl
-- Design      : audio_system_myPrescaler_1_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity audio_system_myPrescaler_1_0 is
  Port ( 
    clk : in STD_LOGIC;
    prescale : out STD_LOGIC
  );

end audio_system_myPrescaler_1_0;

architecture stub of audio_system_myPrescaler_1_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk,prescale";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "myPrescaler,Vivado 2020.2";
begin
end;
