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
	output wEn //amba sends data to usrt
)
  
	reg [2:0] temp; // 0:en, 1:rEn, 2:wEn
	always (@posedge pClk)
	begin
		if(pReset==0) temp=3'b000;
		if else(pSelect==1)
			if(pWrite==1) temp<=3'b101;
			else temp<=3'b011;
		else temp<=3'b000;
	end
	
	assign en=temp[0];
	assign rEn=temp[1];
	assign wEn=temp[2];
endmodule


/*
coordinates data transfer:
-resets everything if recieves reset from the bus (rReset) or pSelect, pWrite is unstable during a transfer
-starts and stops the baud generator for the USRT
-enables data transfer from the USRT to the AMBA when a package is completely deserilialised and unpacked
-enables data transfer from the AMBA to the USRT when the data is ready in the register -> ready for serialization and encoding
*/
module state_reg(
	input pClk,
	input pReset,
	input enable, 	//USRT is selected by the AMBA
	output sendEn,	//data is in the data register and ready to be sent out to the AMBA (pRData)
	output getEn,	//data is in the data register and ready to be sent out to the USRT (Rx)
	output clkEn	//enables the baud rate generator
	output uRst		//resets the baudrate generator and the data registers
)

endmodule

/*
generates 200kHz* clk for the serializer and the deserializer, and the state_reg (according to the Zilog Z844 model)
*/
module baud_gen(
	input pClk,
	input uRst,
	output uClk
)
	
endmodule

/*
recieves a package of 11 bits (1 start, 8 data, 1 parity, 1 stop) 
-checks parity, unpacks the data
-deserializes the 8 data bits

incase of incomplete messegas: drops the package
in case of overrun (unrequested bits): drops the package
in case of  parity error: drops the package
*/
module deserializer(
	input Tx,
	input uClk,
	input uRst,
	output [7:0] data
)
	
endmodule

/*
recieves the data serializes it, and packages it sends it towards Rx
(generates parity bit)
*/
module  serializer(
	input [7:0] data,
	input uClk,
	input uRst,
	output Rx
)

endmodule



/*
collects and stores 8 bit of data, then sends it out 
this will be used for both the serializer and the deserializer to achive data consistency
*/
module data_reg(
	input ready, 	//send the data
	input rst,		//clears the register + disables sending when active
	input clk,
	input [7:0] data_in,
	output[7:0] data_out
)

endmodule

























