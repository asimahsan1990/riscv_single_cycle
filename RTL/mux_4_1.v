module multiplexor_4#(parameter WIDTH=32)(
	input wire [1:0]	sel,
	input wire [WIDTH-1:0] in0 ,
	input wire [WIDTH-1:0] in1,
    input wire [WIDTH-1:0] in2,
    input wire [WIDTH-1:0] in3,
	output reg [WIDTH-1:0] mux_out);
	
always @(*) begin
    case(sel)
    0:mux_out=in0;
    1:mux_out=in1;
    2:mux_out=in2;
    3:mux_out=in3;
    //default:mux_out=in2;
    endcase

end
	
endmodule
