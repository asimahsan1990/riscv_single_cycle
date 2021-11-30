module register#(parameter WIDTH=5)(
		input wire clk,
		input wire rst,
		input wire load,
		input wire [WIDTH-1:0] data_in,
		output reg [WIDTH-1:0] data_out	
		);
		
initial begin
	data_out<=0;
end

always@(posedge clk )
begin
	if (rst==1)
		begin
		data_out<=0;
		end
	else if(load==1)
		begin
			data_out=data_in;
		end

end


endmodule
