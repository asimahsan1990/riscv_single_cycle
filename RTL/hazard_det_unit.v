module hazard_det_unit (
    input [31:0] instr_X,
    input [31:0] instr_D,
    input RegWEn_X,
    output reg Control_set_zero,
    output reg PCWrite,
    output reg instr_X_change

);
initial begin
    PCWrite=1;
end
wire[4:0] instr_D_rs1 = instr_D[19:15];
wire[4:0] instr_D_rs2 =  instr_D[24:20];
wire[4:0] instr_X_rd= instr_X[11:7];

wire [6:0] opcode_X=instr_X[6:0];

always @(*) begin
    if((opcode_X=='h03)& (instr_D_rs1==instr_X_rd ||instr_D_rs1==instr_X_rd) & instr_X_rd!=0)
    begin

            PCWrite=0;
            Control_set_zero=1;
            instr_X_change=1;
    end
    else
        begin
            PCWrite=1;
            Control_set_zero=0;
            instr_X_change=0;
        end
end
    
endmodule