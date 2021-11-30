module memory#(parameter AWIDTH=32,DWIDTH=32)(
  input               clk   ,
  input               wr    ,
  input  [AWIDTH-1:0] addr  ,
  input [DWIDTH-1:0] data_in,
  output [DWIDTH-1:0] data_out

		
);

reg [DWIDTH-1:0] array[0:((1<<AWIDTH) -1)];//

assign data_out = array[addr];


always@(posedge clk)
begin
	 if(wr)
		begin
			array[addr]=data_in;
		end

end



endmodule
