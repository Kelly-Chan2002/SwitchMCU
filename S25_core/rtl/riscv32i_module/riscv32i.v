



module riscv32i 
   # (
    parameter   N_param = 32
   ) (
    input  wire clk,
    input  wire reset,
    input  wire [31:0] Cycle_count

);
    wire  [N_param-1:0]  instruction;
    wire  [4:0] rd_o;
    wire  [4:0] rs1_o;
    wire  [4:0] rs2_o;
    wire  [2:0] fun3_o;
    wire  [6:0] fun7_o;
    wire  [31:0] imm_o;
    wire  [6:0] INST_typ_o, opcode_o;
    wire  [63:0] Single_Instruction_o;
    wire  i_en;

    // param_module params ();
    reg halt_i;
    reg [63:0] pipeReg0;
    reg [511:0] pipeReg1, pipeReg2, pipeReg3;

    wire [63:0]  pipeReg0_wire;
    wire [511:0] pipeReg1_wire, pipeReg2_wire, pipeReg3_wire;
initial begin 
    halt_i          <= 0;
end

    pc pc  (
        .clk_i(clk),
        .reset_i(reset),
        .stage_IF_ready(stage_IF_ready),
        .jump_inst_wire(jump_inst_wire_stage2),
        .branch_inst_wire(branch_inst_wire_stage2),
        .targetPC_i(alu_result_2_stage2),
        .pc_o(pc_i)
    );

    ins_mem ins_mem(
        .clk(clk),
        .reset(reset),
        .pc_i(pc_i),
        .pc_o(pc_o),
        .instruction_o(instruction)
    );

// Pre Stage 0
wire [31:0] pc_stage_0,instruction_stage_0;
wire we_pi;
wire [31:0] pc_o,pc_i;
wire [31:0] writeData_pi,operand1_po,operand2_po;


//stage 1 varibles
wire [31:0] pc_stage_1;
wire [31:0] instruction_stage_1;
wire [ 4:0] rd_stage1;
wire [ 2:0] fun3_stage1;
wire [ 6:0] fun7_stage1;
wire [ 6:0] INST_typ_stage1;
wire [ 6:0] opcode_stage1;
wire [ 4:0] rs1_stage1;
wire [ 4:0] rs2_stage1;
wire [31:0] operand1_stage1;
wire [31:0] operand2_stage1;
wire [31:0] imm_stage1;
wire [63:0] Single_Instruction_stage1;
wire [31:0] alu_result_1;
wire [31:0] alu_result_2;


//stage 2
wire [31:0] pc_stage_2;
wire [31:0] instruction_stage_2;
wire [ 4:0] rd_stage2;
wire [ 2:0] fun3_stage2;
wire [ 6:0] fun7_stage2;
wire [ 6:0] INST_typ_stage2;
wire [ 6:0] opcode_stage2;
wire [ 4:0] rs1_stage2;
wire [ 4:0] rs2_stage2;
wire [31:0] operand1_stage2;
wire [31:0] operand2_stage2;
wire [31:0] imm_stage2;
wire [63:0] Single_Instruction_stage2;
wire [31:0] alu_result_1_stage2;
wire [31:0] alu_result_2_stage2;


//Stage 3
wire [31:0] pc_stage_3;
wire [31:0] instruction_stage_3;
wire [ 4:0] rd_stage3;
wire [ 2:0] fun3_stage3;
wire [ 6:0] fun7_stage3;
wire [ 6:0] INST_typ_stage3;
wire [ 6:0] opcode_stage3;
wire [ 4:0] rs1_stage3;
wire [ 4:0] rs2_stage3;
wire [31:0] operand1_stage3;
wire [31:0] operand2_stage3;
wire [31:0] imm_stage3;
wire [63:0] Single_Instruction_stage3;
wire [31:0] alu_result_1_stage3;
wire [31:0] alu_result_2_stage3;
wire        write_reg_file_wire_stage3;
wire        load_into_reg_stage3;
wire [31:0] loaded_data_stage3;



//Data Mem wires
wire [31:0] loaded_data;
wire load_into_reg;
wire stall_mem_not_avalible;

//Pc
wire branch_inst_wire_stage2;
wire jump_inst_wire_stage2;

//Going into exect
//exec 
wire [31:0] operand1_into_exec;
wire [31:0] operand2_into_exec;
wire [31:0] result_secondary;
wire        jump_inst_wire,branch_inst_wire;


//Hazard
wire write_reg_file_wire_stage2;
wire [31:0] rd_result_stage2;



//Control signals 
wire   delete_reg1_reg2; 
wire   write_reg_stage3;



// Writing to WB regsiter
wire stage_WB_ready;  // Writestage ready for new register
wire stage_MEM_done;  // Memstage done
wire stage3_MEM_valid; // enables new write to PipeReg3

wire stage_MEM_ready;   // MEM  ready for new register
wire stage_EXEC_done;   // EXEC done
wire stage2_EXEC_valid; // enables new write to PipeReg2

wire stage_EXEC_ready;   // EXEC  ready for new register
wire stage_DECO_done;   //  DECO done
wire stage1_DECO_valid; // enables new write to PipeReg1

wire stage_DECO_ready;   // DECO  ready for new register
wire stage_IF_done;      //  IF    done
wire stage0_IF_valid;   // enables new write to PipeReg0

wire stage_IF_ready;   // IF  ready for PC register


//writing into destination reg
assign write_reg_stage3 = write_reg_file_wire_stage3|load_into_reg_stage3;

//flush from branch
assign delete_reg1_reg2 = branch_inst_wire_stage2 | jump_inst_wire_stage2;

//Value being wrtten to regfile in WBB stage, also may be forwarded to ALU
assign writeData_pi     = load_into_reg_stage3 ? loaded_data_stage3 : alu_result_1_stage3;

//Value being wrtten to regfile in MEM stage, also may be forwarded to ALU
assign rd_result_stage2 = load_into_reg ? loaded_data : alu_result_1_stage2;




//MARKER AUTOMATED HERE START

debug # (.Param_delay(5),.regCount(0), .pc_en(1)
                                      ) debug_0 (.i_clk(clk),.pipeReg({448'b0,pipeReg0}), .pc_o(pc_i), .Cycle_count(Cycle_count));
debug # (.Param_delay(10),.regCount(1) ) debug_1 (.i_clk(clk),.pipeReg(pipeReg1));
debug # (.Param_delay(15),.regCount(2) ) debug_2 (.i_clk(clk),.pipeReg(pipeReg2));
debug # (.Param_delay(20),.regCount(3) ) debug_3 (.i_clk(clk),.pipeReg(pipeReg3));

//MARKER AUTOMATED HERE END



    decode #(.N_param(N_param)) decode_debug
    (
   .i_clk(clk),
   .i_en(i_en),
   .instruction(instruction_stage_0),
   .rd_o(rd_o),
   .rs1_o(rs1_o),
   .rs2_o(rs2_o),
   .fun3_o(fun3_o),
   .fun7_o(fun7_o),
   .imm_o(imm_o),
   .INST_typ_o(INST_typ_o),
   .opcode_o(opcode_o),
   .Single_Instruction_o(Single_Instruction_o)
   );


 reg_file reg_file(
.clk(clk),
.reset(reset), 
.reg1_pi(rs1_o), 
.reg2_pi(rs2_o), 
.destReg_pi(rd_stage3), 
.we_pi(write_reg_file_wire_stage3), 
.writeData_pi(writeData_pi), 
.operand1_po(operand1_po),
.operand2_po(operand2_po)
);

execute  #(.N_param(32)) execute 
    (.i_clk(clk),    
     .Single_Instruction_i(Single_Instruction_stage1),
     .operand1_pi(operand1_into_exec),
     .operand2_pi(operand2_into_exec),
     .instruction(instruction_stage_1),
     .pc_i(pc_stage_1),
     .rd_i(rd_stage1),
     .rs1_i(rs1_stage1), 
     .rs2_i(rs2_stage1), 
     .imm_i(imm_stage1),
     .alu_result_1(alu_result_1),
     .alu_result_2(alu_result_2),
     .branch_inst_wire(branch_inst_wire),
     .jump_inst_wire(jump_inst_wire),
     .write_reg_file_wire(write_reg_file_wire)
     
   );


dataMem  #(.mem_size(4096)) dataMem 
  (
.clk(clk),
.reset(reset),
.Single_Instruction(Single_Instruction_stage2),
.address(alu_result_1_stage2),
.storeData(operand2_stage2),
.loadData_w(loaded_data),
.stall_mem_not_avalible(stall_mem_not_avalible),
.load_into_reg(load_into_reg)
);

hazard hazard (
.clk(clk),
.rs1_stage1(rs1_stage1),
.rs2_stage1(rs2_stage1),
.destination_reg_stage2(rd_stage2),
.write_reg_stage2(write_reg_file_wire_stage2),
.destination_reg_stage3(rd_stage3),
.write_reg_stage3(write_reg_stage3),
.PC_stage1(pc_stage_1), 
.PC_stage2(pc_stage_2), 
.PC_stage3(pc_stage_3),
.rd_result_stage2(rd_result_stage2),
.writeData_pi(writeData_pi),
.operand1_stage1(operand1_stage1),
.operand1_into_exec(operand1_into_exec),
.operand2_into_exec(operand2_into_exec),
.operand2_stage1(operand2_stage1)
);


assign pc_stage_0          =        pipeReg0[`PC_reg];
assign instruction_stage_0 =        pipeReg0[`instruct];
assign pc_stage_1 =                 pipeReg1[`PC_reg];
assign instruction_stage_1 =        pipeReg1[`instruct];
assign rd_stage1 =                  pipeReg1[`rd];
assign rs1_stage1 =                 pipeReg1[`opRs1_reg];
assign rs2_stage1 =                 pipeReg1[`opRs2_reg];
assign operand1_stage1 =            pipeReg1[`op1_reg];
assign operand2_stage1 =            pipeReg1[`op2_reg];
assign imm_stage1 =                 pipeReg1[`immediate];
assign Single_Instruction_stage1 =  pipeReg1[`Single_Instruction];


assign pc_stage_2 =                 pipeReg2[`PC_reg];
assign instruction_stage_2 =        pipeReg2[`instruct];
assign rd_stage2 =                  pipeReg2[`rd];
assign rs1_stage2 =                 pipeReg2[`opRs1_reg];
assign rs2_stage2 =                 pipeReg2[`opRs2_reg];
assign operand1_stage2 =            pipeReg2[`op1_reg];
assign operand2_stage2 =            pipeReg2[`op2_reg];
assign imm_stage2 =                 pipeReg2[`immediate];
assign Single_Instruction_stage2 =  pipeReg2[`Single_Instruction];
assign alu_result_1_stage2 =        pipeReg2[`alu_res1          ];
assign alu_result_2_stage2 =        pipeReg2[`alu_res2          ];
assign jump_inst_wire_stage2      = pipeReg2[`jump_en           ];  
assign branch_inst_wire_stage2    = pipeReg2[`branch_en         ];  
assign write_reg_file_wire_stage2 = pipeReg2[`reg_write_en      ];  

assign pc_stage_3 =                 pipeReg3[`PC_reg];
assign instruction_stage_3 =        pipeReg3[`instruct];
assign rd_stage3 =                  pipeReg3[`rd];
assign rs1_stage3 =                 pipeReg3[`opRs1_reg];
assign rs2_stage3 =                 pipeReg3[`opRs2_reg];
assign operand1_stage3 =            pipeReg3[`op1_reg];
assign operand2_stage3 =            pipeReg3[`op2_reg];
assign imm_stage3 =                 pipeReg3[`immediate];
assign Single_Instruction_stage3 =  pipeReg3[`Single_Instruction];
assign alu_result_1_stage3 =        pipeReg3[`alu_res1          ];
assign alu_result_2_stage3 =        pipeReg3[`alu_res2          ];
assign write_reg_file_wire_stage3 = pipeReg3[`reg_write_en      ];  
assign load_into_reg_stage3       = pipeReg3[`load_reg          ];  
assign loaded_data_stage3         = pipeReg3[`data_mem_loaded   ];  


assign pipeReg0_wire[`PC_reg]   = pc_i;
assign pipeReg0_wire[`instruct] = instruction;


assign pipeReg1_wire[`PC_reg            ] = pc_stage_0;
assign pipeReg1_wire[`instruct          ] = instruction_stage_0;
assign pipeReg1_wire[`alu_res1          ] = 0;
assign pipeReg1_wire[`load_reg          ] = 0;
assign pipeReg1_wire[`jump_en           ] = 0;
assign pipeReg1_wire[`branch_en         ] = 0;
assign pipeReg1_wire[`reg_write_en      ] = 0;
assign pipeReg1_wire[`LD_ready          ] = 0;
assign pipeReg1_wire[`SD_ready          ] = 0;
assign pipeReg1_wire[`rd                ] = rd_o;
assign pipeReg1_wire[`operand_amt       ] = 0;
assign pipeReg1_wire[`opRs1_reg         ] = rs1_o;
assign pipeReg1_wire[`opRs2_reg         ] = rs2_o;
assign pipeReg1_wire[`op1_reg           ] = operand1_po;
assign pipeReg1_wire[`op2_reg           ] = operand2_po;
assign pipeReg1_wire[`immediate         ] = imm_o;
assign pipeReg1_wire[`alu_res2          ] = 0;
assign pipeReg1_wire[`rd_data           ] = 0;
assign pipeReg1_wire[`Single_Instruction] = Single_Instruction_o;
assign pipeReg1_wire[`data_mem_loaded   ] = 0;



assign pipeReg2_wire[`PC_reg            ] = pc_stage_1;
assign pipeReg2_wire[`instruct          ] = instruction_stage_1;
assign pipeReg2_wire[`alu_res1          ] = alu_result_1;
assign pipeReg2_wire[`load_reg          ] = 0;
assign pipeReg2_wire[`jump_en           ] = jump_inst_wire;
assign pipeReg2_wire[`branch_en         ] = branch_inst_wire;
assign pipeReg2_wire[`reg_write_en      ] = write_reg_file_wire;
assign pipeReg2_wire[`LD_ready          ] = 0;
assign pipeReg2_wire[`SD_ready          ] = 0;
assign pipeReg2_wire[`rd                ] = rd_stage1;
assign pipeReg2_wire[`operand_amt       ] = 0;
assign pipeReg2_wire[`opRs1_reg         ] = rs1_stage1;
assign pipeReg2_wire[`opRs2_reg         ] = rs2_stage1;
assign pipeReg2_wire[`op1_reg           ] = operand1_into_exec;
assign pipeReg2_wire[`op2_reg           ] = operand2_into_exec;
assign pipeReg2_wire[`immediate         ] = imm_stage1;
assign pipeReg2_wire[`alu_res2          ] = alu_result_2;
assign pipeReg2_wire[`rd_data           ] = 0;
assign pipeReg2_wire[`Single_Instruction] = Single_Instruction_stage1;
assign pipeReg2_wire[`data_mem_loaded   ] = 0;



assign pipeReg3_wire[`PC_reg            ] = pc_stage_2;
assign pipeReg3_wire[`instruct          ] = instruction_stage_2;
assign pipeReg3_wire[`alu_res1          ] = alu_result_1_stage2;
assign pipeReg3_wire[`load_reg          ] = load_into_reg;
assign pipeReg3_wire[`jump_en           ] = 0;
assign pipeReg3_wire[`branch_en         ] = 0;
assign pipeReg3_wire[`reg_write_en      ] = write_reg_file_wire_stage2;
assign pipeReg3_wire[`LD_ready          ] = 0;
assign pipeReg3_wire[`SD_ready          ] = 0;
assign pipeReg3_wire[`rd                ] = rd_stage2;
assign pipeReg3_wire[`operand_amt       ] = 0;
assign pipeReg3_wire[`opRs1_reg         ] = rs1_stage2;
assign pipeReg3_wire[`opRs2_reg         ] = rs2_stage2;
assign pipeReg3_wire[`op1_reg           ] = operand1_stage2;
assign pipeReg3_wire[`op2_reg           ] = operand2_stage2;
assign pipeReg3_wire[`immediate         ] = imm_stage2;
assign pipeReg3_wire[`alu_res2          ] = alu_result_2_stage2;
assign pipeReg3_wire[`rd_data           ] = 0;
assign pipeReg3_wire[`Single_Instruction] = Single_Instruction_stage2;
assign pipeReg3_wire[`data_mem_loaded   ] = loaded_data;


assign stage_MEM_done = ~stall_mem_not_avalible;
assign stage_WB_ready = 1'b1;
assign stage3_MEM_valid = stage_WB_ready & stage_MEM_done;

assign stage_EXEC_done = 1'b1;
assign stage_MEM_ready   = stage3_MEM_valid; // 
assign stage2_EXEC_valid = stage_MEM_ready & stage_EXEC_done;

assign stage_DECO_done = 1'b1;
assign stage_EXEC_ready   = stage2_EXEC_valid; // 
assign stage1_DECO_valid = stage_EXEC_ready & stage_DECO_done;

assign stage_IF_done = 1'b1;
assign stage_DECO_ready   = stage1_DECO_valid; // 
assign stage0_IF_valid = stage_DECO_ready & stage_IF_done;

//for PC counter 

assign stage_IF_ready   = stage0_IF_valid; // 


always @(posedge clk)begin
if (reset) begin 
    pipeReg0 <= 64'b0;
    pipeReg1 <= 512'b0;
    pipeReg2 <= 512'b0;
	pipeReg3 <= 512'b0;
end else if (delete_reg1_reg2) begin 
    pipeReg0 <= 64'b0;
    pipeReg1 <= 512'b0;
    pipeReg2 <= 512'b0;

    if (stage3_MEM_valid) begin      // <-- stage 2 // 
        pipeReg3 <= pipeReg3_wire;  
     end else begin
        pipeReg3 <= pipeReg3;
     end

end else begin 

    if (stage0_IF_valid) begin 
        pipeReg0   <= pipeReg0_wire;
    end else begin 
        pipeReg0   <= pipeReg0;
    end 
    if (stage1_DECO_valid) begin
        pipeReg1 <= pipeReg1_wire;
    end else begin 
        pipeReg1 <= pipeReg1;
    end 

    if (stage2_EXEC_valid) begin
        pipeReg2 <= pipeReg2_wire ;     
    end else begin 
        pipeReg2 <= pipeReg2;
    end

    if (stage3_MEM_valid) begin
        pipeReg3 <= pipeReg3_wire;  
    end else begin
        pipeReg3 <= pipeReg3;
    end


end //end else from reset
end // end clock



 
endmodule













