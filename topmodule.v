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
output Tx
);

  
  

endmodule
