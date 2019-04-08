//==================================================================
//INPUTS + OUTPUTS
//==================================================================


//AMBA side
reg [7:0] pWData; 
reg [7:0] pRData;
reg pWrite;
reg pSelect;
wire pEnable;
wire pClk;
reg pReset;
reg [32:0] pAddress;
reg pReady;
assign pslverr = 0;


//USRT side
reg [7:0] inData;
wire [7:0] outData;
wire uClk;
reg dir; //dir<=~pWrite

