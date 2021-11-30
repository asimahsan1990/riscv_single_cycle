module branch_compare #(
    parameter WIDTH=32
) (
    input[WIDTH-1:0] rs1,
    input[WIDTH-1:0] rs2,
    input BrUn,
    output reg BrEq,
    output reg BrLT);
    
    always @(*) begin
        case (BrUn)
            0:begin
                BrEq=$signed(rs1)==$signed(rs2);
                BrLT=$signed(rs1)<$signed(rs2);
            end
            1:begin
                BrEq=$unsigned(rs1)==$unsigned(rs2);
                BrLT=$unsigned(rs1)<$unsigned(rs2);
            end  
 
        endcase
    end
    
endmodule
