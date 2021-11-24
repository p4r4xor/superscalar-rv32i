//
// RISC-V RV32I CPU Hazard detection unit & MUX
//
module risc_v_32_hazard(memread,inst_decode,ifid_rs1,ifid_rs2,idex_rd,pc_write,ifid_write,MUX_out);
    
    input         memread;                          // memory read
    input  [36:0] inst_decode;                      // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst
    input   [4:0] ifid_rs1;                         // rs1
    input   [4:0] ifid_rs2;                         // rs2
    input   [4:0] idex_rd;                          // rd
    
    output        pc_write;                         // update pc
    output        ifid_write;                       // update ifid regiest
    output [36:0] MUX_out;                          // MUX output
    
    wire          stall;
    reg    [36:0] MUX_out;
    
/*  always @ (*) begin
        stall = 0;
        if (memread && ((idex_rd == ifid_rs1) || (idex_rd == ifid_rs2)))    stall = 1;
    end
*/
    assign stall = (memread && ((idex_rd == ifid_rs1) || (idex_rd == ifid_rs2)));
    
    assign   pc_write = ~stall;
    assign ifid_write = ~stall;
    
    
    
    //MUX
    always @ (stall, inst_decode) begin
        MUX_out = 0;
        case (~stall)
            1'b0:   MUX_out = 0;
            1'b1:   MUX_out = inst_decode;
        endcase
    end
    
    
endmodule

