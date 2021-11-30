module memory_load#(parameter WIDTH=32) (
    input[WIDTH-1:0] data_in,
    input[2:0] load_op,
    output reg[WIDTH-1:0] data_out
     
);

always @(*) begin
    case (load_op)
        0:data_out=$signed (data_in[7:0]) ;//lb
        1:data_out=$signed (data_in[15:0]) ;//lh
        2:data_out=$signed (data_in[31:0]) ;//lw
        3:data_out=data_in;//ld
        4:data_out=$unsigned (data_in[7:0]) ;//lbu
        5:data_out=$unsigned (data_in[15:0]) ;//lhu
        6:data_out=$unsigned (data_in[31:0]) ;//lwu
    default:
            data_out=data_in;//ld
    endcase
end
    
endmodule