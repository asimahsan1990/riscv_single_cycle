module tb_top_module();

reg clk;
reg rst;
integer i;

Top_module instance1(.clk(clk),
                  .rst(rst));
initial begin
    clk=0;
    rst=0;
    $readmemh("data.hex", instance1.data_memory.array);
    instance1.regfile.array[0]=0;
    instance1.regfile.array[1]=1;
    instance1.regfile.array[2]=2;
    instance1.regfile.array[3]=3;
    instance1.regfile.array[4]=4;
    instance1.regfile.array[5]=5;
    instance1.regfile.array[6]=6;
    instance1.regfile.array[7]=7;
    instance1.regfile.array[16]=-16;
    instance1.regfile.array[17]=2;
    
    $readmemh("instruction.hex", instance1.instruction_memory.array);
    //{instance1.instruction_memory.array[3],instance1.instruction_memory.array[2],instance1.instruction_memory.array[1],instance1.instruction_memory.array[0]}=32'h00007033;//nop and
    //{instance1.instruction_memory.array[7],instance1.instruction_memory.array[6],instance1.instruction_memory.array[5],instance1.instruction_memory.array[4]}=32'h00100093;//nop addi x1,x0, 1
    //{instance1.instruction_memory.array[11],instance1.instruction_memory.array[10],instance1.instruction_memory.array[9],instance1.instruction_memory.array[8]}=32'h00208433;//add r8,r1,r2
    //{instance1.instruction_memory.array[15],instance1.instruction_memory.array[14],instance1.instruction_memory.array[13],instance1.instruction_memory.array[12]}=32'h404404b3;////sub r9,r8,r4
    //{instance1.instruction_memory.array[19],instance1.instruction_memory.array[18],instance1.instruction_memory.array[17],instance1.instruction_memory.array[16]}=32'h00317533;//and r10 = r2 & r3
    //{instance1.instruction_memory.array[23],instance1.instruction_memory.array[22],instance1.instruction_memory.array[21],instance1.instruction_memory.array[20]}=32'h0041e5b3;//or  r11 = r3 | r4 
    //{instance1.instruction_memory.array[27],instance1.instruction_memory.array[26],instance1.instruction_memory.array[25],instance1.instruction_memory.array[24]}=32'h00000603;//lb x12 0(x0)//h411857B3;//nop sra x15,x16,x17
    //{instance1.instruction_memory.array[31],instance1.instruction_memory.array[30],instance1.instruction_memory.array[29],instance1.instruction_memory.array[28]}=32'h00007033;//nop
    //instance1.instruction_memory.array[3:0]=32'h00007033;
    //instance1.instruction_memory.array[7:4]=32'h00007033;
    //instance1.instruction_memory.array[7:4]=32'h00007033;

end                  

always #5 clk=~clk;


endmodule