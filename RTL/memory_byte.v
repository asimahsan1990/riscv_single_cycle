module memory_byte#(parameter AWIDTH=32,DPORT=32,DWIDTH=8)(
  input               clk   ,
  input               wr    ,
  input	[1:0]			  byte,
  input  [AWIDTH-1:0] addr  ,
  input [DPORT-1:0] data_in,
  output [DPORT-1:0] data_out

		
);

reg [DWIDTH-1:0] array[0:((1<<AWIDTH) -1)];//
assign data_out = {array[addr+3],array[addr+2],array[addr+1],array[addr]};


always@(posedge clk)
begin
	 if(wr)
		begin
			case (byte)
				0:array[addr]=data_in[7:0];
				1:{array[addr+1],array[addr]}=data_in[15:0];
				2:{array[addr+3],array[addr+2],array[addr+1],array[addr]}=data_in;
				default:
					{array[addr+3],array[addr+2],array[addr+1],array[addr]}=data_in;
			endcase
			
		end

end



endmodule
