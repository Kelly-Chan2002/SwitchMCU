module exu_reg_wbu_top(
    hclk                                            ,
    hrstn                                           ,
    cycle_cnt                                       ,
    ifu_dec_stall                                   ,
    inst_in                                         ,
    inst_out                                        ,
    dec_lui                                         ,
    dec_auipc                                       ,
    dec_jal                                         ,
    dec_jalr                                        ,
    dec_beq                                         ,
    dec_bne                                         ,
    dec_blt                                         ,
    dec_bge                                         ,
    dec_bltu                                        ,
    dec_bgeu                                        ,
    dec_lb                                          ,
    dec_lh                                          ,
    dec_lw                                          ,
    dec_lbu                                         ,
    dec_lhu                                         ,
    dec_sb                                          ,
    dec_sh                                          ,
    dec_sw                                          ,
    dec_addi                                        ,
    dec_slti                                        ,
    dec_sltiu                                       ,
    dec_xori                                        ,
    dec_ori                                         ,
    dec_andi                                        ,
    dec_slli                                        ,
    dec_srli                                        ,
    dec_srai                                        ,
    dec_add                                         ,
    dec_sub                                         ,
    dec_sll                                         ,
    dec_slt                                         ,
    dec_sltu                                        ,
    dec_xor                                         ,
    dec_srl                                         ,
    dec_sra                                         ,
    dec_or                                          ,
    dec_and                                         ,
    dec_fence                                       ,
    dec_fence_i                                     ,
    dec_ecall                                       ,
    dec_ebreak                                      ,
    dec_csrrw                                       ,
    dec_csrrs                                       ,
    dec_csrrc                                       ,
    dec_csrrwi                                      ,
    dec_csrrsi                                      ,
    dec_csrrci                                      ,
    dec_upper_en                                    ,
    dec_imm_en                                      ,
    dec_reg_en                                      ,
    dec_jump_en                                     ,
    dec_branch_en                                   ,
    dec_load_en                                     ,
    dec_store_en                                    ,
    dec_rs2                                         ,
    dec_rs1                                         ,
    dec_rd                                          ,
    dec_imm_type_i                                  ,
    dec_imm_type_s                                  ,
    dec_imm_type_b                                  ,
    dec_imm_type_u                                  ,
    dec_imm_type_j                                  ,
    pc                                              ,
    pc_write                                        ,
    pc_wdata                                        ,
    exu_load_rd                                     ,
    exu_load_base_addr                              ,
    exu_load_offset                                 ,
    exu_load_sext                                   ,
    exu_load_size                                   ,
    exu_load_en                                     ,
    exu_store_addr                                  ,
    exu_store_data                                  ,
    exu_store_size                                  ,
    exu_store_en                                    ,
    reg_waddr                                       ,
    reg_wdata                                       ,
    reg_wen                                         ,
    reg_raddr_1                                     ,
    reg_rdata_1                                     ,
    reg_ren_1                                       ,
    reg_raddr_2                                     ,
    reg_rdata_2                                     ,
    reg_ren_2                                       ,
    mau_load_rd                                     ,
    mau_load_data                                   ,
    mau_load_en
);

// general signals
input                   hclk                        ;
input                   hrstn                       ;
// instruction
input       [31:0]      inst_in                     ;
output reg  [31:0]      inst_out                    ;
// signals from decoder
input                   dec_lui                     ;
input                   dec_auipc                   ;
input                   dec_jal                     ;
input                   dec_jalr                    ;
input                   dec_beq                     ;
input                   dec_bne                     ;
input                   dec_blt                     ;
input                   dec_bge                     ;
input                   dec_bltu                    ;
input                   dec_bgeu                    ;
input                   dec_lb                      ;
input                   dec_lh                      ;
input                   dec_lw                      ;
input                   dec_lbu                     ;
input                   dec_lhu                     ;
input                   dec_sb                      ;
input                   dec_sh                      ;
input                   dec_sw                      ;
input                   dec_addi                    ;
input                   dec_slti                    ;
input                   dec_sltiu                   ;
input                   dec_xori                    ;
input                   dec_ori                     ;
input                   dec_andi                    ;
input                   dec_slli                    ;
input                   dec_srli                    ;
input                   dec_srai                    ;
input                   dec_add                     ;
input                   dec_sub                     ;
input                   dec_sll                     ;
input                   dec_slt                     ;
input                   dec_sltu                    ;
input                   dec_xor                     ;
input                   dec_srl                     ;
input                   dec_sra                     ;
input                   dec_or                      ;
input                   dec_and                     ;
input                   dec_fence                   ;
input                   dec_fence_i                 ;
input                   dec_ecall                   ;
input                   dec_ebreak                  ;
input                   dec_csrrw                   ;    
input                   dec_csrrs                   ;
input                   dec_csrrc                   ;
input                   dec_csrrwi                  ;
input                   dec_csrrsi                  ;
input                   dec_csrrci                  ;
input                   dec_upper_en                ;
input                   dec_imm_en                  ;
input                   dec_reg_en                  ;
input                   dec_jump_en                 ;
input                   dec_branch_en               ;
input                   dec_load_en                 ;
input                   dec_store_en                ;
input       [4:0]       dec_rs2                     ;
input       [4:0]       dec_rs1                     ;
input       [4:0]       dec_rd                      ;
input       [11:0]      dec_imm_type_i              ;
input       [11:0]      dec_imm_type_s              ;
input       [12:0]      dec_imm_type_b              ;
input       [19:0]      dec_imm_type_u              ;
input       [20:0]      dec_imm_type_j              ;
// PC reg       
input       [31:0]      pc                          ; 
output                  pc_write                    ;
output      [31:0]      pc_wdata                    ; 
// signals to memory access
output      [4:0]       exu_load_rd                 ;
output      [31:0]      exu_load_base_addr          ;
output      [31:0]      exu_load_offset             ;
output                  exu_load_sext               ;
output      [1:0]       exu_load_size               ;
output                  exu_load_en                 ;
output      [31:0]      exu_store_addr              ;
output      [31:0]      exu_store_data              ;
output      [1:0]       exu_store_size              ;
output                  exu_store_en                ;
// regfile      
output      [4:0]       reg_waddr                   ;
output      [31:0]      reg_wdata                   ;
output                  reg_wen                     ;
output      [4:0]       reg_raddr_1                 ;
input       [31:0]      reg_rdata_1                 ;
output                  reg_ren_1                   ;
output      [4:0]       reg_raddr_2                 ;
input      [31:0]       reg_rdata_2                 ;
output                  reg_ren_2                   ;
// control signals
input       [3:0]       cycle_cnt                   ;
output                  ifu_dec_stall               ;

//WBU extra signals
input [4:0]   mau_load_rd;
input [31:0]  mau_load_data;
input         mau_load_en;


exu_top_swc exu_top_inst (
  .hclk			(hclk                           ),
  .hrstn		(hrstn                          ),
  .cycle_cnt		(cycle_cnt			),
  .ifu_dec_stall	(ifu_dec_stall			),
  .inst_in		(inst_in			),
  .inst_out		(inst_out			),
  .dec_lui		(dec_lui			),
  .dec_auipc		(dec_auipc			),
  .dec_jal		(dec_jal			),
  .dec_jalr		(dec_jalr			),
  .dec_beq		(dec_beq			),
  .dec_bne		(dec_bne			),
  .dec_blt		(dec_blt			),
  .dec_bge		(dec_bge			),
  .dec_bltu		(dec_bltu			),
  .dec_bgeu		(dec_bgeu			),
  .dec_lb		(dec_lb				),
  .dec_lh		(dec_lh 			),
  .dec_lw		(dec_lw				),
  .dec_lbu		(dec_lbu 			),
  .dec_lhu		(dec_lhu			),
  .dec_sb		(dec_sb				),
  .dec_sh		(dec_sh				),
  .dec_sw		(dec_sw				),
  .dec_addi		(dec_addi			),
  .dec_slti		(dec_slti			),
  .dec_sltiu		(dec_sltiu			),
  .dec_xori		(dec_xori			),
  .dec_ori		(dec_ori 			),
  .dec_andi		(dec_andi			),
  .dec_slli		(dec_slli 			),
  .dec_srli		(dec_srli			),
  .dec_srai		(dec_srai			),
  .dec_add		(dec_add			),
  .dec_sub		(dec_sub			),
  .dec_sll		(dec_sll			),
  .dec_slt		(dec_slt			),
  .dec_sltu		(dec_sltu			),
  .dec_xor		(dec_xor			),
  .dec_srl		(dec_srl			),
  .dec_sra		(dec_sra			),
  .dec_or		(dec_or				),
  .dec_and		(dec_and			),
  .dec_fence		(dec_fence			),
  .dec_fence_i		(dec_fence_i			),
  .dec_ecall		(dec_ecall			),
  .dec_ebreak		(dec_ebreak			),
  .dec_csrrw		(dec_csrrw			),
  .dec_csrrs		(dec_csrrs			),
  .dec_csrrc		(dec_csrrc			),
  .dec_csrrwi		(dec_csrrwi			),
  .dec_csrrsi		(dec_csrrsi			),
  .dec_csrrci		(dec_csrrci			),
  .dec_upper_en		(dec_upper_en			),
  .dec_imm_en		(dec_imm_en			),
  .dec_reg_en		(dec_reg_en			),
  .dec_jump_en		(dec_jump_en			),
  .dec_branch_en	(dec_branch_en			),
  .dec_load_en		(dec_load_en			),
  .dec_store_en		(dec_store_en			),
  .dec_rs2		(dec_rs2			),
  .dec_rs1		(dec_rs1			),
  .dec_rd		(dec_rd				),
  .dec_imm_type_i	(dec_imm_type_i			),
  .dec_imm_type_s	(dec_imm_type_s			),
  .dec_imm_type_b	(dec_imm_type_b			),
  .dec_imm_type_u	(dec_imm_type_u			),
  .dec_imm_type_j	(dec_imm_type_j			),
  .pc			(pc				),
  .pc_write		(pc_write			),
  .pc_wdata		(pc_wdata			),
  .exu_load_rd		(exu_load_rd			),
  .exu_load_base_addr	(exu_load_base_addr		),
  .exu_load_offset	(exu_load_offset		),
  .exu_load_sext	(exu_load_sext			),
  .exu_load_size	(exu_load_size			),
  .exu_load_en		(exu_load_en			),
  .exu_store_addr	(exu_store_addr			),
  .exu_store_data	(exu_store_data			),
  .exu_store_size	(exu_store_size			),
  .exu_store_en		(exu_store_en			),
  .reg_waddr		(reg_waddr			),
  .reg_wdata		(reg_wdata			),
  .reg_wen		(reg_wen			),
  .reg_raddr_1		(reg_raddr_1			),
  .reg_rdata_1		(reg_rdata_1			),
  .reg_ren_1		(reg_ren_1			),
  .reg_raddr_2		(reg_raddr_2			),
  .reg_rdata_2		(reg_rdata_2			),
  .reg_ren_2		(reg_ren_2			)
);

regfile_swc regfile_inst (
    hclk                                  (hclk),
    hrstn                                (hrstn),
    reg_waddr                        (reg_waddr),
    reg_wen                            (reg_wen),
    reg_wdata                        (reg_wdata),
    reg_raddr_1                    (reg_raddr_1),
    reg_ren_1                        (reg_ren_1),
    reg_rdata_1                    (reg_rdata_1),
    reg_raddr_2                    (reg_raddr_2),
    reg_ren_2                        (reg_ren_2),
    reg_rdata_2                    (reg_rdata_2)
);

wbu_swc wbu_inst (
    hclk                                  (hclk),
    hrstn                                (hrstn),
    cycle_cnt                        (cycle_cnt),
    mau_load_rd                    (mau_load_rd),
    mau_load_data                (mau_load_data),
    mau_load_en                    (mau_load_en),
    reg_waddr                        (reg_waddr),
    reg_wen                            (reg_wen),
    reg_wdata                        (reg_wdata)
);

endmodule