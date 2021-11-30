module register_file #(parameter DWIDTH=32)(
  input               clk   ,
  input               wr    ,
  input  [4:0]        Addr_A ,
  input  [4:0]        Addr_B ,
  input  [4:0]        Addr_D ,
  input [DWIDTH-1:0] Data_D,
  output [DWIDTH-1:0] Data_A,
  output [DWIDTH-1:0] Data_B
	
);

reg [DWIDTH-1:0] array[0:31];//
assign Data_A = Addr_A?array[Addr_A]:0;
assign Data_B = Addr_B?array[Addr_B]:0;

always@(posedge clk)
begin
	array[0]=0;
	 if(wr)
		begin
            array[Addr_D]=Data_D;
		end

end



endmodule
