//
// RISC-V RV32I CPU Pipeline Register EX/MEM
//
module exmemreg(clk,clrn,inst_i,pc_i,next_pc_i,m_addr_i,d_t_mem_i,wreg_i,wr_i,wmem_i,rmem_i,i_load_i,alu_out_i,PCSrc_i,inst_decode_i,inst_o,pc_o,next_pc_o,m_addr_o,d_t_mem_o,wreg_o,wr_o,wmem_o,rmem_o,i_load_o,alu_out_o,PCSrc_o,inst_decode_o);
    input             clk, clrn;                             // clock and reset
    input      [31:0] pc_i;                                  // program counter
    input      [31:0] next_pc_i;                             // program counter
    input      [31:0] inst_i;                                // instruction
    input      [31:0] m_addr_i;                              // mem addr 
    input      [31:0] d_t_mem_i;                             // store data
    input             wreg_i;                                // write regfile 
    input       [4:0] wr_i;                                  // reg to write
    input             wmem_i;                                // write memory
    input             rmem_i;                                // read memory
    input             i_load_i;                              // write to register file
    input      [31:0] alu_out_i;                             // alu output
    input             PCSrc_i;                               // pc MUX control signal
    input      [36:0] inst_decode_i;                         // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst
    
    output reg [31:0] next_pc_o;                             // program counter
    output reg [31:0] inst_o;                                // instruction
    output reg [31:0] pc_o;                                  // program counter
    output reg [31:0] m_addr_o;                              // mem addr 
    output reg [31:0] d_t_mem_o;                             // store data
    output reg        wreg_o;                                // write regfile 
    output reg  [4:0] wr_o;                                  // reg to write
    output reg        wmem_o;                                // write memory
    output reg        rmem_o;                                // read memory
    output reg        i_load_o;                              // write to register file
    output reg [31:0] alu_out_o;                             // alu output
    output reg        PCSrc_o;                               // pc MUX control signal
    output reg [36:0] inst_decode_o;                         // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst

    always @ (posedge clk) begin
        if (clrn) begin
            next_pc_o     <= next_pc_i;
            inst_o        <= inst_i;
            pc_o          <= pc_i;
            m_addr_o      <= m_addr_i;
            d_t_mem_o     <= d_t_mem_i;
            wreg_o        <= wreg_i;
            wr_o          <= wr_i;
            wmem_o        <= wmem_i;
            rmem_o        <= rmem_i;
            i_load_o      <= i_load_i;
            alu_out_o     <= alu_out_i;
            PCSrc_o       <= PCSrc_i;
            inst_decode_o <= inst_decode_i;
        end
        else begin
            next_pc_o     <= 0;
            inst_o        <= 0;
            pc_o          <= 0;
            m_addr_o      <= 0;
            d_t_mem_o     <= 0;
            wreg_o        <= 0;
            wr_o          <= 0;
            wmem_o        <= 0;
            rmem_o        <= 0;
            i_load_o      <= 0;
            alu_out_o     <= 0;
            PCSrc_o       <= 0;
            inst_decode_o <= 0;
        end
    end
    
endmodule

