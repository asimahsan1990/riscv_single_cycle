module Top_module(input clk,
                  input rst);

    localparam width =32 ;


    //PC wire
    wire[width-1:0] pc_in;
    wire[width-1:0] pc_4;
    wire[width-1:0] pc_out;
    wire PCWrite;

    wire instr_X_change;

    // PC adder
    assign pc_4 =pc_out+4;//pc +4

    //ALU wire
    wire[width-1:0] ALU_Output;

    //imm gen
    wire [width-1:0] Imm;

    //controller wires
    wire[3:0] ALUSel;
    wire PCSel;
    wire RegWEn;
    wire BSel;
    wire[1:0] WBSel;
    wire[2:0] ImmSel;
  
  //data memory
    wire [width-1:0] data_memory_out;

        //program counter pipeline

    reg [width-1:0] pc_D,pc_X,pc_M,pc_W;
    
    //instr pipline
    reg [width-1:0] instr_D,instr_X,instr_M,instr_W;

    //reg file data pipline
    reg [width-1:0] rs1_X,rs2_X,rs2_M;

    //ALU pipline
    reg [width-1:0] ALU_M,ALU_W;

    //read memory
    reg [width-1:0] mem_read;

      //controller pipeline
    reg RegWEn_X,RegWEn_M,RegWEn_W,ASel_X,BSel_X,BrUn_X;
    reg [3:0]ALUSel_X;
    reg [2:0]ImmSel_X;
    reg MemRW_X,MemRW_M;
    reg [2:0] load_op_X,load_op_M;
    reg [1:0] write_op_X,write_op_M;
    reg [1:0] WBSel_X,WBSel_M,WBSel_W;


    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    pc_add4_mux
   (
    .sel     ( 1'b0   ),
    .in0     ( pc_4 ),
    .in1     ( ALU_Output ),
    .mux_out ( pc_in   ) 
   ) ;


    

    
    register
    #(
        .WIDTH    ( width ) 
    )
        program_counter_register
    (
        .clk      ( clk    ),
        .rst      ( rst    ),
        .load     ( PCWrite ),
        .data_in  ( pc_in  ),
        .data_out (   pc_out )
    ) ;


    always @(posedge clk) begin
      pc_D<=pc_out;
      pc_X<=pc_D;
      pc_M<=pc_X;
      pc_W<=pc_M+4;
    end

  wire [31:0] instr;


  memory_byte#(.AWIDTH(10),.DWIDTH(8), .DPORT(32) )
        instruction_memory(
        .clk(clk)     ,
        .wr(1'b0)      ,
  			.byte(2'b0)       ,
        .addr(pc_out)  ,
        .data_in(32'b0),
        .data_out(instr)		
);
  

  always @(posedge clk) begin
    if(instr_X_change)
          begin
            instr_X<='h00007033;//nop and x0 x0 x0
          end
    else
        begin
          instr_X<=instr_D;
          instr_D<=instr;
        end
    //instr_D<=instr;
    instr_M<=instr_X;
    instr_W<=instr_M;
  end





wire[width-1:0] Oprand_A;
wire[width-1:0] Oprand_B;
wire[width-1:0] WB;
wire[width-1:0] D_Scr_MM;


always @(posedge clk) begin
      rs1_X<=Oprand_A;
      rs2_X<=Oprand_B;
      rs2_M<=D_Scr_MM;
end

wire [width-1:0] t_instr_D;
    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    stall_instr_mux
   (
    .sel     ( instr_X_change  ),
    .in0     ( instr_D),
    .in1     ( 'h00007033 ),//nop and x0,x0,x0
    .mux_out ( t_instr_D   ) 
   ) ;


   hazard_det_unit hazard_det_unit_instance (
    .instr_X(instr_X),
    .instr_D(instr_D),
    .RegWEn_X(RegWEn_X),
    .Control_set_zero(),
    .PCWrite(PCWrite),
    .instr_X_change(instr_X_change)

);


    register_file#(.DWIDTH(width))
      regfile(
      .clk(clk)   ,
      .wr(RegWEn_W)    ,
      .Addr_A(t_instr_D[19:15]) ,
      .Addr_B (t_instr_D[24:20]),
      .Addr_D (instr_W[11:7]),
      .Data_D(WB),
      .Data_A(Oprand_A),
      .Data_B(Oprand_B)
      
    );

    Imm_Gen #(.WIDTH(width))Imm_instance(
        .instr(instr_X),
        .ImmSel(ImmSel_X),
        .Imm(Imm)

    );

wire BrUn,BrEq,BrLT;

branch_compare #(
    .WIDTH(width)
) branch_comparator (
        .rs1(rs1_X),
        .rs2(rs2_X),
        .BrUn(BrUn),
        .BrEq(BrEq),
        .BrLT(BrLT));

wire[width-1:0] Source_A;
wire[width-1:0] D_Scr_A;
wire ASel;

wire [1:0] FSEL_A;
wire [1:0] FSEL_B;
wire [1:0]FSEL_MEM;

    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    source_a_sel_mux
   (
    .sel     ( ASel_X   ),
    .in0     ( rs1_X ),
    .in1     ( pc_X ),
    .mux_out ( D_Scr_A   ) 
   ) ;
  multiplexor_4
  #(
    .WIDTH   ( width  ) 
   )
    forward_source_sel_A_mux
   (
    .sel     ( FSEL_A  ),
    .in0     ( D_Scr_A ),
    .in1     ( ALU_M ),
    .in2     ( WB ),
    .in3     ( D_Scr_A ),//NC // output
    .mux_out ( Source_A   ) 
   ) ;

wire[width-1:0] Source_B;
wire[width-1:0] D_Scr_B;

    multiplexor
  #(
    .WIDTH   ( width  ) 
   )
    source_B_sel_mux
   (
    .sel     ( BSel_X   ),
    .in0     ( rs2_X ),
    .in1     ( Imm ),
    .mux_out ( D_Scr_B   ) 
   ) ;

       multiplexor_4
  #(
    .WIDTH   ( width  ) 
   )
    forward_source_sel_B_mux
   (
    .sel     (  FSEL_B ),
    .in0     ( D_Scr_B ),
    .in1     ( ALU_M ),
    .in2     ( WB ),
    .in3     ( D_Scr_B ),//NC // output
    .mux_out ( Source_B   ) 
   ) ;


          multiplexor_4
  #(
    .WIDTH   ( width  ) 
   )
    forward_source_mm_mux
   (
    .sel     (  FSEL_MEM ),
    .in0     ( D_Scr_B ),
    .in1     ( ALU_M ),
    .in2     ( WB ),
    .in3     ( D_Scr_B ),//NC // output
    .mux_out ( D_Scr_MM ) 
   ) ;


   


   forward_unit  fw_control( 
    .instr_X(instr_X) ,
    .instr_M(instr_M),
    .instr_W(instr_W),
    .RegWEn_M(RegWEn_M),
    .RegWEn_W(RegWEn_W),
    .FSEL_A(FSEL_A),
    .FSEL_B(FSEL_B),
    .FSEL_MEM(FSEL_MEM)

);



    alu#(.WIDTH(width))
    alu_instance(
    .ALUSel(ALUSel_X) ,
    .in_a(Source_A)   ,
    .in_b(Source_B)   ,
    .alu_out(ALU_Output)
    );

    

    always @(posedge clk) begin
      ALU_M<=ALU_Output;
      ALU_W<=ALU_M;
    end



    wire[1:0] write_op;
    wire MemRW;

    memory_byte#(.AWIDTH(10),.DWIDTH(8), .DPORT(32) )
        data_memory(
        .clk(clk)     ,
        .wr(MemRW_M)      ,
  			.byte(write_op)       ,
        .addr(ALU_M)  ,
        .data_in(rs2_M),
        .data_out(data_memory_out)		
      );

      wire[2:0] load_op;
      wire [width-1:0] data_parsing_out;

memory_load#(.WIDTH(width)) load_memory (
    .data_in(data_memory_out),
    .load_op(load_op),
    .data_out(data_parsing_out)
     
    );


always @(posedge clk) begin
    mem_read<=data_parsing_out;
end

   

    multiplexor_4
  #(
    .WIDTH   ( width  ) 
   )
    reg_file_source_sel_mux
   (
    .sel     ( WBSel_W  ),
    .in0     ( mem_read ),
    .in1     ( ALU_W ),
    .in2     ( pc_W ),
    .in3     ( ALU_W ),//NC // output
    .mux_out ( WB   ) 
   ) ;

   



    controller controller_inst(
    .instr(t_instr_D),
    .BrEq(BrEq),
    .BrLT(BrLT),

    .PCSel(PCSel),
    .RegWEn(RegWEn),//x
    .ImmSel(ImmSel),//x
    .BSel(BSel),//x
    .WBSel(WBSel),//x->m->w
    .MemRW(MemRW),//x->m
    .BrUn(BrUn),//x
    .ASel(ASel),//x
    .ALUSel(ALUSel),//x
    .load_op(load_op),////x->m
    .write_op(write_op)//x->m
    );


always @(posedge clk) begin
  RegWEn_X<=RegWEn;
  RegWEn_M<=RegWEn_X;
  RegWEn_W<=RegWEn_M;

  ASel_X<=ASel;
  BSel_X<=BSel;

  BrUn_X<=BrUn;
  ALUSel_X<=ALUSel;
  ImmSel_X<=ImmSel;

  MemRW_X<=MemRW;
  MemRW_M<=MemRW;

  load_op_X<=load_op;
  load_op_M<=load_op_X;

  write_op_X<=write_op;
  write_op_M<=write_op_X;

  WBSel_X<=WBSel;
  WBSel_M<=WBSel_X;
  WBSel_W<=WBSel_M;


end


    
  
endmodule