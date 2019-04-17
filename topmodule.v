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
input Rx,
input uRst,
output Tx
);
wire en;
wire rEn;
wire wEn;
enable enable_top(pClk, pReset,pReady, pSelect, pWrite,pAddress,pEnable,en,rEn,wEn);
wire uClk;
reg data;
baud_gen baudgen_top(pClk, uRst,uClk);
deserializer deserializer_top(Tx, uClk,uRst,en,data);
serializer serializer_top(inData,uClk,uRst,en,Rx);
data_reg datareg_top(en,pReset,uClk,data,data);


endmodule
