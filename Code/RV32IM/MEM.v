//
// RISC-V RV32I CPU MEM 
//


module risc_v_32_mem(m_addr,d_f_mem,inst_decode,mem_out);
								 
	input  [31:0] m_addr;                                    // mem or i/o addr
    input  [31:0] d_f_mem;                                   // load data
    input  [36:0] inst_decode;								 // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst
	
	output reg [31:0] mem_out;                               // mem output

	// instruction
    wire          i_lb    = inst_decode[10]; // lb
    wire          i_lh    = inst_decode[11]; // lh
    wire          i_lw    = inst_decode[12]; // lw
    wire          i_lbu   = inst_decode[13]; // lbu
    wire          i_lhu   = inst_decode[14]; // lhu



	always @(*) begin                                      // load instructions
        mem_out = 0;                                       // mem output
        case (1'b1)
            i_lw: begin                                    // lw
                mem_out = d_f_mem;end
            i_lbu: begin                                   // lbu
                case(m_addr[1:0])
                  2'b00: mem_out = {24'h0,d_f_mem[ 7: 0]};
                  2'b01: mem_out = {24'h0,d_f_mem[15: 8]};
                  2'b10: mem_out = {24'h0,d_f_mem[23:16]};
                  2'b11: mem_out = {24'h0,d_f_mem[31:24]};
                endcase end
            i_lb: begin                                    // lb
                case(m_addr[1:0])
                  2'b00: mem_out = {{24{d_f_mem[ 7]}},d_f_mem[ 7: 0]};
                  2'b01: mem_out = {{24{d_f_mem[15]}},d_f_mem[15: 8]};
                  2'b10: mem_out = {{24{d_f_mem[23]}},d_f_mem[23:16]};
                  2'b11: mem_out = {{24{d_f_mem[31]}},d_f_mem[31:24]};
                endcase end
            i_lhu: begin                                   // lhu
                case(m_addr[1])
                  1'b0: mem_out = {16'h0,d_f_mem[15: 0]};
                  1'b1: mem_out = {16'h0,d_f_mem[31:16]};
                endcase end
            i_lh: begin                                    // lh
                case(m_addr[1])
                  1'b0: mem_out = {{16{d_f_mem[15]}},d_f_mem[15: 0]};
                  1'b1: mem_out = {{16{d_f_mem[31]}},d_f_mem[31:16]};
                endcase end
            default: ;
        endcase
    end

	
endmodule
