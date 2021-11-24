//
// RISC-V RV32I CPU
//
module riscv(

    input wire               clk,
    input wire               rst,        // high is reset
    
    // inst_mem
    input wire[31:0]         inst_i,
    output wire[31:0]        inst_addr_o,
    output wire              inst_ce_o, //chip enable, always be 1 in this lab

    // data_mem
    input wire[31:0]         data_i,      // load data from data_mem
    output wire              data_we_o,
    output wire              data_ce_o,
    output wire[31:0]        data_addr_o,
    output wire[31:0]        data_o       // store data to  data_mem

);

//  instance your module  below
wire clrn = !rst;

wire        PCSrc1,PCSrc2;                           // MUX choose signal
wire [31:0] pc1;                                     // program counter
wire [31:0] pc2;                                     // program counter
wire [31:0] pc3;                                     // program counter
wire [31:0] pc4;                                     // program counter
wire [31:0] pc5;                                     // program counter
wire [31:0] inst1;                                   // instruction
wire [31:0] inst2;                                   // instruction
wire [31:0] inst3;                                   // instruction
wire [31:0] inst4;                                   // instruction
wire [31:0] inst5;                                   // instruction
wire [31:0] pc_o;                                    // program counter
wire [36:0] inst_decode1;                            // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst 
wire [36:0] inst_decode2;                            // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst 
wire [36:0] inst_decode3;                            // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst 
wire [31:0] imm1;                                    // the extended immediate 
wire [31:0] imm2;                                    // the extended immediate 
wire [4:0]  rd11,rd12;                               // = rs1
wire [4:0]  rd21,rd22;                               // = rs2
wire [4:0]  wr1;                                     // reg to write
wire [4:0]  wr2,wr3,wr4;                             // reg to write
wire        i_load1,i_load2,i_load3;                 // MentoReg
wire        wreg1,wreg2,wreg3;                       // if == 1, write register
wire [31:0] read_data11,read_data12;
wire [31:0] read_data21,read_data22;
wire [31:0] m_addr1,m_addr2;                         // mem or i/o addr
wire [31:0] d_t_mem_i,d_t_mem_o;                     // store data
wire        wmem1,wmem2;                             // write memory
wire        rmem1,rmem2;                             // read memory
wire [31:0] data_2_rf;                               // data write to register file
wire [31:0] alu_out1,alu_out2,alu_out3;              // alu output
wire [31:0] mem_out1,mem_out2;                       // mem output
wire [31:0] next_pc1,next_pc2;                       // next pc
wire        pc_write;                                // write pc
wire        ifid_write;                              // write ifid register
wire [36:0] MUX_out;                                 // MUX output
wire [31:0] a,b;                                     // ALU inputs

assign data_ce_o = rmem2 | wmem2;
assign data_we_o = wmem2;
assign data_addr_o = m_addr2;
assign data_o = d_t_mem_i;
assign inst_addr_o = pc1;
assign inst_ce_o = 1;

risc_v_32_if IF(clk,clrn,inst_i,next_pc1,PCSrc1,pc_write,pc1,inst1);

ifidreg ifid(clk,clrn,ifid_write,PCSrc1,pc1,inst1,pc2,inst2);

risc_v_32_id ID(inst2,pc2,pc_o,inst_decode1,imm1,rd11,rd21,wr1);

risc_v_32_regfile regfile(clk,clrn,rd11,rd21,wr4,data_2_rf,wreg3,read_data11,read_data21);

risc_v_32_hazard hazard(rmem1,inst_decode1,rd11,rd21,wr2,pc_write,ifid_write,MUX_out);

idexreg idex(clk,clrn,PCSrc1,inst2,pc2,MUX_out,imm1,read_data11,read_data21,wr1,rd11,rd21,inst3,pc3,inst_decode2,imm2,read_data12,read_data22,wr2,rd12,rd22);

risc_v_32_forward forward(read_data12,data_2_rf,alu_out2,read_data22,data_2_rf,alu_out2,rd12,rd22,wreg2,wr3,wreg3,wr4,a,b);

risc_v_32_ex EX(pc3,a,b,inst3,inst_decode2,imm2,m_addr1,d_t_mem_i,wreg1,wmem1,rmem1,i_load1,alu_out1,next_pc1,PCSrc1);

exmemreg exmem(clk,clrn,inst3,pc3,next_pc1,m_addr1,d_t_mem_i,wreg1,wr2,wmem1,rmem1,i_load1,alu_out1,PCSrc1,inst_decode2,inst4,pc4,next_pc2,m_addr2,d_t_mem_o,wreg2,wr3,wmem2,rmem2,i_load2,alu_out2,PCSrc2,inst_decode3);

risc_v_32_mem MEM(m_addr2,data_i,inst_decode3,mem_out1);

memwbreg memwb(clk,clrn,pc4,inst4,mem_out1,alu_out2,wreg2,wr3,i_load2,pc5,inst5,mem_out2,alu_out3,wreg3,wr4,i_load3);

risc_v_32_wb WB(mem_out2,alu_out3,i_load3,data_2_rf);


endmodule