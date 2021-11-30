module control #(parameter AWIDTH = 5, DWIDTH = 32, OWIDTH = 7)(
	
	//INPUT TO THE CONTROLLER
	input [DWIDTH-1:0] instr,

	//OUTPUTS FROM THE CONTROLLER
	output [AWIDTH-1:0] ALUSel
);
	
	assign opcode = instr [7:0];
	assign func3 = instr [14:12];
	assign func7 = instr [25:31];
	case (opcode) 
		7'h33: 
			case (func3)
				3'b000: ALUSel = func7[5] ? 4'b0001 : 4'b0000;
				3'b001: ALUSel = 4'b 0010;
				3'b010: ALUSel = 4'b 0100;
				3'b011: ALUSel = 4'b 0110;
				3'b100: ALUSel = 4'b 1000;
				3'b101: ALUSel = func7[5] ? 4'b1011 : 4'b1010;
				3'b110: ALUSel = 4'b 1100;
				3'b111: ALUSel = 4'b 1110;
			endcase
	endcase
endmodule
