//
// RISC-V RV32I CPU Pipeline Register IF/ID
//
module ifidreg(clk,clrn,ifid_write,PCsrc,pc_i,inst_i,pc_o,inst_o);
    input             clk, clrn;                             // clock and reset
    input             ifid_write;                            // write ifid register
    input             PCsrc;                                 // pc MUX control signal
    input      [31:0] pc_i;                                  // program couter
    input      [31:0] inst_i;                                // instruction
    output reg [31:0] pc_o;                                  // program couter
    output reg [31:0] inst_o;                                // instruction
    
    always @ (posedge clk) begin
        if (clrn && ifid_write && (!PCsrc)) begin
            pc_o   <= pc_i;
            inst_o <= inst_i;
        end
        else if (!ifid_write) ;
        else begin
            pc_o   <= 0;
            inst_o <= 0;
        end
    end
    
endmodule
