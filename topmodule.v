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
  //USRT
output Rx,
input Tx
);
  
  
wire en;
wire rEn;
wire wEn;
wire uClk;
wire uRst;
wire [10:0] data_read;
wire [10:0] data_write;

enable enable_top(pClk, pReset,pReady, pSelect, pWrite,pAddress,pEnable,en,rEn,wEn);
baud_gen baudgen_top(pClk,en,uClk);
uRst_gen uRstgen_top(pClk,uClk,pReset,uRst);
  
deserializer deserializer_top(Tx,uClk,rEn,uRst,data_read);
  read_reg readreg_top(pClk,pRst,data_read,pRData);  

serializer serializer_top(data_write,uClk,wEn,uRst,Rx);
  write_reg writereg_top(pWData,pRst,pClk,wEn,data_write);
  
endmodule
