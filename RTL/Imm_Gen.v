module Imm_Gen#(parameter WIDTH=32)(
    input[31:0] instr,
    input [2:0] ImmSel,
    output reg [WIDTH-1:0]Imm

);



always @(*) begin
    case(ImmSel)
        0:Imm=$signed(instr[31:20]);
        1:Imm=$unsigned(instr[31:20]);
        2:Imm=$unsigned(instr[24:20]);
        3:Imm=$unsigned({instr[31:25],instr[11:7]});
        4:Imm=$signed({instr[31],instr[7],instr[30:25],instr[11:8],1'b0});
        5:Imm=$signed({Imm[31],Imm[19:12],Imm[20],Imm[30:21],1'b0});
        6:Imm={instr[31:12],12'h000};
        default:Imm=$signed(instr[31:20]);
    endcase
end




endmodule