`timescale 1ns / 1ps
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
	input pAddr,
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
generates 200kHz* clk for the serializer and the deserializer, and the state_reg (according to the Zilog Z844 model)
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
		else
			counter<=counter+1;
	end
	
	assign uClk=(counter==79)? 1 : 0;
	
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
	input rEn,
	input en, //basically the pReady&pSelect
	output [7:0] data
);

reg [7:0] temp;
reg [3:0] counter;
reg t_flag;

always@(posedge uClk)
	if(en)	
	begin
	counter<=counter+1;
	if(rEn)
		begin
		counter<=0;
		temp<=0;
		end	
	else if(counter==0)
		t_flag<=1;
	else if(counter==0 && Tx!=1)
		counter<=0; //startbit check fail
	else if(counter>0 && counter!=9)
		temp[counter-1]<=Tx; //data bits
	else if(counter==9 && Tx!=temp[0]^temp[1]^temp[2]^temp[3]^temp[4]^temp[5]^temp[6]^temp[7])
		begin
		counter<=0; //parity check fail
		temp<=0;
		end
	else if(counter==10 && Tx!=0)
		begin
		temp<=0; //stop bit check fail
		counter<=0;
		end
	else if(counter==10)
		t_flag<=0;
	else if(t_flag==1)
	begin
		temp<=0;
		counter<=0;
		t_flag<=0;
	end
end
	assign data=temp;
endmodule

/*
recieves the data serializes it, and packages it sends it towards Rx
(generates parity bit)
*/
module  serializer(
	input [7:0] data,
	input uClk,
	input wEn,
	input en, //basicall the pSelect
	output Rx
);
reg [3:0] counter;
reg temp;
reg t_flag;

always @(posedge uClk)
	if(en)
	begin
	counter<=counter+1;
		if(wEn)
		begin
		counter<=0;
		temp<=0;
		end
		else if(counter==0)
		begin
			temp<=1; //startbit
			t_flag<=1;
		end
		else if(counter>0 && counter!=9)
		temp<=data[counter-1]; //data bits
		else if(counter==9)
		temp<=data[0]^data[1]^data[2]^data[3]^data[4]^data[5]^data[6]^data[7]; //parity bit
		else if(counter==10)
		begin
		temp<=0; //stop bit
		counter<=0;
		t_flag<=0;
		end
	 end
	else if(t_flag==1)
		begin
		counter<=0;
		temp<=0;
		t_flag<=0;
		end
 
 assign Rx=temp;

endmodule

/*
collects and stores 8 bit of data, then sends it out 
this will be used for both the serializer and the deserializer to achive data consistency
*/
module data_reg(
	input ready, 	//lock the data and send it send the data
	input rst,	//clears the register + disables sending when active
	input clk,
	input [7:0] data_in,
	output[7:0] data_out
);
	reg [7:0] temp_in;
	
	always@(posedge clk)
	begin
		if(rst)
			temp_in<=0;
		else if(ready==0)
			temp_in<=data_in;
	end
	
	assign data_out=temp_in;
	
endmodule

//right shift reg module
module shift_reg (
  input clk,
  input rst, 
  input [7:0] data,
  output[7:0] data_out
);
  reg [7:0] temp;
  
  always @(posedge clk)
  begin
      if(rst)
        temp<= 0;
      else
        temp<={data[0],data[6:1]};
  end
  assign data_out=temp;
endmodule

