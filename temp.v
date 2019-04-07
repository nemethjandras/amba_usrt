//AMBA
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


//USRT
reg [7:0] inData;
wire [7:0] outData;
wire uClk;
reg dir; //dir<=~pWrite

//==================================================================
//MODULOK
//==================================================================

module enable(
  input pClk,
  input pReset,
  input pReady,
  input pSelect,
  input pWrite,
  output en, //usrt selected
  output rEn, //usrt can send data to amba
  output wEn, //amba sends data to usrt
)
  
  reg [2:0] temp; // 0:en, 1:rEn, 2:wEn
  
  
  always (@posedge pClk)
    if(pReset==0) temp=3'b000;
    if else(pSelect==1)
      if(pWrite==1) temp<=3'b101;
  		else temp<=3'b011;
  	else temp<=3'b000;
  
  
  assign en=temp[0];
  assign rEn=temp[1];
  assign wEn=temp[2];
endmodule
