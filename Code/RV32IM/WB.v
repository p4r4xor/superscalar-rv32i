//
// RISC-V RV32I CPU WB 
//


module risc_v_32_wb(mem_out,alu_out,MemtoReg,data_2_rf);
    input      [31:0] mem_out;                                   // Read data from data memory
	input      [31:0] alu_out;									 // ALU output
	input 	          MemtoReg;									 // MUX choose signal
    output 	   [31:0] data_2_rf;								 // data write to register file

    wire   [31:0] data_2_rf = MemtoReg ? mem_out : alu_out;

	
endmodule