//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2019 05:49:26 PM
// Design Name: 
// Module Name: modules
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
//Inputs and outputs for reference
//==================================================================
/*
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
*/

//==================================================================
//MODULOK
//==================================================================

module enable(
	input pClk,
	input pReset,
	input pReady,
	input pSelect,
	input pWrite,
	input [32:0] pAddr,
	input pEnable,
	output en, //usrt selected >> starts the baudgenerator
	output rEn, //usrt can send data to amba >> enables the deserializer
	output wEn //amba sends data to usrt >> enables the serializer
);
reg [2:0] temp;
always @ (posedge pClk)
	begin
		if(pReset==0) temp=3'b000;
		else if(pSelect==1 && pEnable==1)
	      if(pWrite==1 && pReady==1) 
	      temp<=3'b101;
	      else if(pWrite!=1 && pReady==1)
		  temp<=3'b011;
	      else 
	      temp<=3'b000;
	end
	assign en=temp[0];
	assign rEn=temp[1];
	assign wEn=temp[2];
endmodule


/*
generates 200kHz* clk for the serializer and the deserializer, and the state_reg 
(according to the Zilog Z844 model)
*/
module baud_gen(
	input pClk,
	input en,
	output uClk
);
	reg [6:0] counter;
	always@(posedge pClk)
	begin
		if(en)
			counter<=0;
		else if(counter==79)
			counter<=0;
		else
		    counter<=counter+1;
	end
	
	assign uClk=(counter==79)? 1 : 0;
	
endmodule

//generates uRst from pRst, the USRT modules can only use uRst
//uRst is the reset signal aligned to uClk s it will only activaty if uClk is active!
module uRst_gen(
	input pClk,
	input uClk,
	input pRst,
	output uRst
);
    reg reset_flag;
	reg reset_out;
	
	always@(posedge pClk)
	begin
	if(pRst) reset_flag<=1;
	end
	
	always@(posedge uClk)
	if(reset_flag)
		begin
		reset_flag<=0;
		reset_out<=0;
		end
	else reset_out<=0;	
	
	assign uRst=reset_out;
	
endmodule

//deserializes a package from the UART and hand it to the read register
//if the enable is inconsistent during the 11 uCLK period, the whole read process is canceled
module deserializer(
	input Tx,
	input uClk,
	input rEn,
	input uRst,
	output [10:0] data
);

reg [10:0] temp;
reg [3:0] counter;
reg send_flag;

always@(posedge uClk)
	begin
		if(uRst || !rEn)
		begin
			temp<=0;
			counter<=0;
			send_flag<=0;
		end
		else
		begin
			counter<=counter+1;
			send_flag<=0;
			temp[counter]<=Tx;
			if(counter==10)
			counter<=0;
			send_flag<=1;
		end
	end
	assign data=(send_flag)? temp : 0;
endmodule

//connects the data from the UART to the AMBA if its consistent with USRT protocols rules
module read_reg(
	input pClk,
	input pRst,
	input [10:0] data_in,
	output [7:0]data_out
);
reg out_en;

always@(posedge pClk)
	begin
		if(pRst) out_en=0;
		else if(data_in[0]==1 && data_in[10]==0 && data_in[9]==data_in[0]^data_in[1]^data_in[2]^data_in[3]^data_in[4]^data_in[5]^data_in[6]^data_in[7])
		out_en<=1;
	end
	
assign data_out=(out_en)? data_in[9:1] : 8'bzzzzzzzz;
endmodule

//connects the data from the AMBA to the UART, and encapsulates it according to the USRT protocol
module write_reg(
input [7:0] data_in,
input pRst,
input pClk,
input wEn,
output [10:0] data_out
);

reg [10:0] temp;

always@(posedge pClk)
begin
	if(pRst || !wEn)
	temp=0;
	else if(wEn)
	begin
		temp[0]<=1;
		temp[8:1]<=data_in;
		temp[9]<=data_in[0]^data_in[1]^data_in[2]^data_in[3]^data_in[4]^data_in[5]^data_in[6]^data_in[7];
		temp[10]<=0;
	end
end

assign data_out=temp;
endmodule



/*
recieves the data serializes it
*/
module  serializer(
	input [10:0] data,
	input uClk,
	input wEn,
	input uRst,
	output Rx
);
reg [3:0] counter;
reg temp;
reg t_flag;

always @(posedge uClk)
begin
	if(uRst || !wEn) 
	counter<=0;
	else
	begin
		counter<=counter+1;
		temp<=data[counter];
		if(counter==10)
		counter<=0;
	end
end
 
 assign Rx=(wEn)? temp : 1'bz;

endmodule



