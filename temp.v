//right shift reg module
module shift_reg (
  input clk,
  input rst, 
  input [7:0] data,
  output data_out
)
  reg [7:0] temp;
  
  always@(posedge clk)
    begin
      if(rst)
        temp<=data[0];
      else
        temp<=temp[0,6:1];
    end
  
  assign data_out=temp[0];
endmodule
