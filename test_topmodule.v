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
reg [7:0] pRData;
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
end
endtask


//write task (usrt >>data>> amba)
//1 transfers lasts 13*80 tick in simulation
task write();
begin
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
Tx = 0;

#20
pReset = 1;




end


always #1 pClk = ~pClk;
always #80 uClk_ref=~uClk_ref;
endmodule













