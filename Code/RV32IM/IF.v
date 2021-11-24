//
// RISC-V RV32I CPU IF 
//


module risc_v_32_if(clk,clrn,inst_i,MUX_1,PCSrc,pc_write,pc,inst_o);
	input         clk, clrn;                                 // clock and reset
    input  [31:0] inst_i;                                    // instruction
	input  [31:0] MUX_1;									 // addr for jump
	input 		  PCSrc;									 // MUX choose signal
	input		  pc_write;									 // write pc
    output [31:0] pc;                                        // program counter
	output [31:0] inst_o;                                    // instruction


	reg   [31:0]  next_pc;                                   // next pc
    wire  [31:0]  pc_plus_4 = pc + 4;                        // pc + 4

	always @ (*) begin
		if (PCSrc)	next_pc = MUX_1;
		else 		next_pc = pc_plus_4;
	end
	
	// pc
    reg  [31:0]    pc;
    always @ (posedge clk or negedge clrn) begin
        if (!clrn) 				pc <= 0;
        else if (pc_write)      pc <= next_pc;
    end
	
	assign inst_o = inst_i;
	
endmodule