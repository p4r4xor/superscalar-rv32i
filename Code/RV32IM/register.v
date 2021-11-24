//
// RISC-V RV32I CPU Registerfile
//

module risc_v_32_regfile(clk,clrn,rd1,rd2,wr,wd,wreg,read_data1,read_data2);
    input         clk, clrn;                             // clock and reset
    input  [4:0]  rd1;                                   // read register1
    input  [4:0]  rd2;                                   // read register2
    input  [4:0]  wr;                                    // write register
    input  [31:0] wd;                                    // write data
    input         wreg;                                  // if == 1, write register
    output [31:0] read_data1;
    output [31:0] read_data2;
    
    reg  [31:0] regfile [1:31];
    
    
    wire [31:0]   read_data1 = (rd1==0) ? 0 : regfile[rd1];           // read port
    wire [31:0]   read_data2 = (rd2==0) ? 0 : regfile[rd2];           // read port
    
    always @ (negedge clk) begin
        if (wreg && (wr != 0)) begin
            regfile[wr] <= wd;                      // write port
        end
    end
    
endmodule