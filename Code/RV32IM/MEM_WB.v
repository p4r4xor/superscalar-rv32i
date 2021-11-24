//
// RISC-V RV32I CPU Pipeline Register MEM/WB
//
module memwbreg(clk,clrn,pc_i,inst_i,mem_out_i,alu_out_i,wreg_i,wr_i,memtoreg_i,pc_o,inst_o,mem_out_o,alu_out_o,wreg_o,wr_o,memtoreg_o);
    input             clk, clrn;                             // clock and reset
    input      [31:0] pc_i;                                  // program couter
    input      [31:0] inst_i;                                // instruction
    input      [31:0] mem_out_i;                             // mem output
    input      [31:0] alu_out_i;                             // alu output
    input             wreg_i;                                // write to reg
    input       [4:0] wr_i;                                  // reg to write
    input             memtoreg_i;                            // memory to register


    output reg [31:0] pc_o;                                  // program couter
    output reg [31:0] inst_o;                                // instruction
    output reg [31:0] mem_out_o;                             // mem output
    output reg [31:0] alu_out_o;                             // alu output
    output reg        wreg_o;                                // write to reg
    output reg  [4:0] wr_o;                                  // reg to write
    output reg        memtoreg_o;                            // memory to register  
    
    
    always @ (posedge clk) begin
        if (clrn) begin
            pc_o       <= pc_i;
            inst_o     <= inst_i;
            mem_out_o  <= mem_out_i;
            alu_out_o  <= alu_out_i;
            wreg_o     <= wreg_i;
            wr_o       <= wr_i;
            memtoreg_o <= memtoreg_i;
        end
        else begin
            pc_o       <= 0;
            inst_o     <= 0;
            mem_out_o  <= 0;
            alu_out_o  <= 0;
            wreg_o     <= 0;
            wr_o       <= 0;
            memtoreg_o <= 0;
        end
    end
    
endmodule

