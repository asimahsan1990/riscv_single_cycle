module forward_unit ( 
    input [31:0] instr_X ,
    input [31:0] instr_M,
    input [31:0] instr_W,
    input RegWEn_M,
    input RegWEn_W,
    output reg [1:0] FSEL_A,
    output reg [1:0] FSEL_B,
    output reg [1:0] FSEL_MEM


);

wire[4:0] instr_X_rs1 = instr_X[19:15];
wire[4:0] instr_X_rs2 =  instr_X[24:20];
wire[6:0] instr_X_opcode=instr_X[6:0];

wire[4:0] instr_M_rd= instr_M[11:7];
wire[4:0] instr_W_rd= instr_W[11:7];

always @(*) begin
    if(RegWEn_M & (instr_M_rd!=0)& (instr_X_rs1==instr_M_rd))
    begin
        FSEL_A=1;
    end
    else if (RegWEn_W & (instr_W_rd!=0)& (instr_X_rs1==instr_W_rd))
    begin
        FSEL_A=2;
    end
    else
    begin
        FSEL_A=0;
    end

    if(RegWEn_M & (instr_M_rd!=0)& (instr_X_rs2==instr_M_rd) &(instr_X_opcode=='h3) )
    begin
        if(instr_X_opcode=='h23)
        begin
            FSEL_B=0;
            FSEL_MEM=1;
        end
        else
        begin
            FSEL_B=1;
            FSEL_MEM=0;
        end
    end
        else if (RegWEn_W & (instr_W_rd!=0)& (instr_X_rs2==instr_W_rd)&(instr_X_opcode=='h3))
    begin
        if(instr_X_opcode=='h23)
        begin
            FSEL_B=0;
            FSEL_MEM=2;
        end
        else
        begin
            FSEL_B=2;
            FSEL_MEM=0;
        end
    end
    else
    begin
        FSEL_B=0;
        FSEL_MEM=0;
    end
end
    
endmodule