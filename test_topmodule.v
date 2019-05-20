`timescale 1ns / 1ps

module test_topmodule;

//inputs
reg [7:0] pWData; 
reg pWrite;
reg pSelect;
reg pEnable;
reg  pClk;
reg pReset;
reg [31:0]pAddress;
reg pReady;
reg Rx;

//outputs
wire Tx;
wire [7:0] pRData;

//test outputs
wire en_o;
wire rEn_o;
wire wEn_o;
wire uClk_o;
wire uRst_o;
wire [10:0] dr_o;
wire [10:0] dw_o;

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
.Rx(Rx),
  
//testing only 
.en_o(en_o),
.rEn_o(rEn_o),
.wEn_o(wEn_o),
.uClk_o(uClk_o),
.uRst_o(uRst_o),
.dr_o(dr_o),
.dw_o(dw_o)
);

//read task (usrt <<data<< ambe)
task read();
begin
  //initialize
#2
  pAddress[31]<=1;
  pWrite<=0;
  pSelect<=1;
#2
  pEnable<=1;
  pReady<=0;
  //sending data, while amba is in wait states
#80
  Rx<=1;
#80
  Rx<=0;
#80
  Rx<=0;
#80
  Rx<=0;
#80
  Rx<=1;
#80
  Rx<=1;
#80
  Rx<=1;
#80
  Rx<=0;
#80
  Rx<=0;
#80
  Rx<=1;
#80
  Rx<=0;
#80
  //reading out data on the AMBA side
  pReady<=1;
#2
  pReady<=0;
  pSelect<=0;
  pEnable<=0;
end
endtask


//write task (usrt >>data>> amba)
task write();
begin
  //initialize
   #2
  pAddress[31]<=0;
  pWrite<=1;
  pSelect<=1;
  //sending data
  pWData<= 8'b11110000;
  #2
  pEnable<=1;
  pReady<=0;
  //wait states
  #960
  //end data sending
  pWData<=8'b00000000;
  pReady<=1;
  pEnable<=0;
  pSelect<=0;
end
endtask


initial begin
// Initialize Inputs
pClk = 1;
pReset = 0; //active reset to set up modules
pSelect = 0;
pEnable = 0;
pWrite = 0;
pAddress = 0;
pWData = 0;
pReady=1;
Rx = 0;
#20
//disableing reset
pReset = 1;
#100;
//data transfer test

read();
write();


end

always #1 pClk = ~pClk;
endmodule
