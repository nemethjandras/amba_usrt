`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.04.2019 21:43:49
// Design Name: 
// Module Name: test_topmodule
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


module test_topmodule;

//inputs
reg [7:0] pWData; 
reg pWrite;
reg pSelect;
reg pEnable;
reg  pClk;
reg pReset;
reg [32:0] pAddress;
reg pReady;
reg Tx;

//outputs
wire Rx;
reg [7:0] pRData;
//variable for ease of use
reg uClk_ref;

//initialize tested module
topmodule uut(
.pWData(pWData),
.pRData(pRData),
.pWrite(pWrite),
.pSelect(pSelect),
.pEnable(pEnable),
.pClk(pClk),
.pReset(pReset),
.pAddress(pAddress),
.pReady(pReady),
.Tx(Tx),
.Rx(Rx)
);

//read task (usrt <<data<< ambe)
//1 transfers lasts 13*80 tick in simulation
task read();
begin
#1
  //pAddress????
  pWrite=0;
  pSelect=1;
#2
  pEanble=1;
  pReady=0;
#82
  Tx=1;
#161
  Tx=0;
#242
  Tx=0;
#322
  Tx=0;
#402
  Tx=1;
#482
  Tx=1;
#562
  Tx=1;
#642
  Tx=0;
#722
  Tx=0;
#802
  Tx=1;
#882
  Tx=0;
#962
  pReady=1;
#963
  pReady=0;
  pSelect=0;
  pEnable=0;
end
endtask


//write task (usrt >>data>> amba)
//1 transfers lasts 13*80 tick in simulation
task write();
begin
   #1
  //paddr használjuk? 
  pWrite=1;
  pSelect=1;
  pData=8'b11111100;
  #2
  pEnable=1;
  pReady=0;
  #962
  pWData=0;
  pready=1;
  pEable=0;
  pSelect=0;
end
endtask


initial begin
// Initialize Inputs
pClk = 0;
pReset = 0;
pSelect = 0;
pEnable = 0;
pWrite = 0;
pAddress = 0;
pWData = 0;
pReady=1;
Tx = 0;

#20
pReset = 1;

//taskok

always #1 pClk = ~pClk;
always #80 uClk_ref=~uClk_ref;
endmodule













