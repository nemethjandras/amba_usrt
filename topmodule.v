`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2019 05:53:33 PM
// Design Name: 
// Module Name: topmodule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
//==================================================================
//INPUTS + OUTPUTS
//==================================================================

module topmodule(
  //AMBA
input [7:0] pWData,
input [7:0] pRData,
input pWrite,
input pSelect,   
input pEnable,
input  pClk,
input pReset,
input [32:0] pAddress,
input pReady,
input [7:0] inData,
output [7:0] outData,
  //USRT
output Rx,
input Tx
);
wire en;
wire rEn;
wire wEn;
enable enable_top(pClk, pReset,pReady, pSelect, pWrite,pAddress,pEnable,en,rEn,wEn);
wire uClk;
wire [7:0] data_in;
wire [7:0] data_out;
wire [7:0] to_shift_data_out;
wire [7:0] to_shift_data_in;
baud_gen baudgen_top(pClk,en,uClk);
deserializer deserializer_top(Tx, uClk,rEn,en,data_out);
data_reg datareg_top_TX(pReady,pReset,uClk,data_out,to_shift_data_in);
data_reg datareg_top_RX(pReady,pReset,uClk,data_in,to_shift_data_out);
serializer  serializer_top(pWData,uClk,wEn,en,data_in);





endmodule
