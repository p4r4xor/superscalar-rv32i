//
// RISC-V RV32I CPU Pipeline Register ID/EX
//
module idexreg(clk,clrn,PCsrc,inst_i,pc_i,inst_decode_i,imm_in,read_data1_i,read_data2_i,wr_i,rs1_i,rs2_i,inst_o,pc_o,inst_decode_o,imm_out,read_data1_o,read_data2_o,wr_o,rs1_o,rs2_o);
    input             clk, clrn;                             // clock and reset
    input             PCsrc;                                 // pc MUX control signal
    input      [31:0] pc_i;                                  // program counter
    input      [31:0] inst_i;                                // instruction
    input      [36:0] inst_decode_i;                         // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst 
    input      [31:0] imm_in;                                // the extended immediate // already shift
    input      [31:0] read_data1_i;                          // read_data1 from regfile
    input      [31:0] read_data2_i;                          // read_data2 from regfile
    input       [4:0] wr_i;                                  // reg to write
    input       [4:0] rs1_i;                                 // reg1 to read
    input       [4:0] rs2_i;                                 // reg2 to read
    
    output reg [31:0] pc_o;                                  // program counter
    output reg [31:0] inst_o;                                // instruction
    output reg [36:0] inst_decode_o;                         // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst 
    output reg [31:0] imm_out;                               // the extended immediate // already shift
    output reg [31:0] read_data1_o;                          // read_data1 from regfile
    output reg [31:0] read_data2_o;                          // read_data2 from regfile
    output reg  [4:0] wr_o;                                  // reg to write
    output reg  [4:0] rs1_o;                                 // reg1 to read
    output reg  [4:0] rs2_o;                                 // reg2 to read
        
    always @ (posedge clk) begin
        if (clrn && (!PCsrc)) begin
            pc_o          <= pc_i;
            inst_o        <= inst_i;
            inst_decode_o <= inst_decode_i;
            imm_out       <= imm_in;
            read_data1_o  <= read_data1_i;
            read_data2_o  <= read_data2_i;
            wr_o          <= wr_i;
            rs1_o         <= rs1_i;
            rs2_o         <= rs2_i;
        end
        else begin
            pc_o          <= 0;
            inst_o        <= 0;
            inst_decode_o <= 0;
            imm_out       <= 0;
            read_data1_o  <= 0;
            read_data2_o  <= 0;
            wr_o          <= 0;
            rs1_o         <= 0;
            rs2_o         <= 0;
        end
    end
    
endmodule
