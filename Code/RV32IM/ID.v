//
// RISC-V RV32I CPU ID
//


module risc_v_32_id(inst,pc_i,pc_o,inst_decode,imm_out,rd1,rd2,wr);
    input  [31:0] inst;                                  // instruction
	input  [31:0] pc_i;									 // program counter
    output [31:0] pc_o;                                  // program counter
	output [36:0] inst_decode;							 // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst 
														 // see line 28-64 //attention for the order
	output reg [31:0] imm_out;							 // the extended immediate // already shift
	output [4:0]  rd1;									 // = rs1
	output [4:0]  rd2;									 // = rs2
	output [4:0]  wr;									 // reg to write
	
	// instruction format
    wire [6:0]    opcode = inst[6:0];   // 
    wire [2:0]    func3  = inst[14:12]; // 
    wire [6:0]    func7  = inst[31:25]; // 
    wire [4:0]    rd     = inst[11:7];  // 
    wire [4:0]    rs     = inst[19:15]; // = rs1
    wire [4:0]    rt     = inst[24:20]; // = rs2
    wire [4:0]    shamt  = inst[24:20]; // = rs2;    
    wire          sign   = inst[31];
	
	assign rd1  = rs;
	assign rd2  = rt;
	assign wr   = rd;
	assign pc_o = pc_i;
	
	
	// instruction decode
    wire          i_auipc = (opcode == 7'b0010111); // auipc
    wire          i_lui   = (opcode == 7'b0110111); // lui
    wire          i_jal   = (opcode == 7'b1101111); // jal
    wire          i_jalr  = (opcode == 7'b1100111) & (func3 == 3'b000); // jalr
    wire          i_beq   = (opcode == 7'b1100011) & (func3 == 3'b000); // beq
    wire          i_bne   = (opcode == 7'b1100011) & (func3 == 3'b001); // bne
    wire          i_blt   = (opcode == 7'b1100011) & (func3 == 3'b100); // blt
    wire          i_bge   = (opcode == 7'b1100011) & (func3 == 3'b101); // bge
    wire          i_bltu  = (opcode == 7'b1100011) & (func3 == 3'b110); // bltu
    wire          i_bgeu  = (opcode == 7'b1100011) & (func3 == 3'b111); // bgeu
    wire          i_lb    = (opcode == 7'b0000011) & (func3 == 3'b000); // lb
    wire          i_lh    = (opcode == 7'b0000011) & (func3 == 3'b001); // lh
    wire          i_lw    = (opcode == 7'b0000011) & (func3 == 3'b010); // lw
    wire          i_lbu   = (opcode == 7'b0000011) & (func3 == 3'b100); // lbu
    wire          i_lhu   = (opcode == 7'b0000011) & (func3 == 3'b101); // lhu
    wire          i_sb    = (opcode == 7'b0100011) & (func3 == 3'b000); // sb
    wire          i_sh    = (opcode == 7'b0100011) & (func3 == 3'b001); // sh
    wire          i_sw    = (opcode == 7'b0100011) & (func3 == 3'b010); // sw
    wire          i_addi  = (opcode == 7'b0010011) & (func3 == 3'b000); // addi
    wire          i_slti  = (opcode == 7'b0010011) & (func3 == 3'b010); // slti
    wire          i_sltiu = (opcode == 7'b0010011) & (func3 == 3'b011); // sltiu
    wire          i_xori  = (opcode == 7'b0010011) & (func3 == 3'b100); // xori
    wire          i_ori   = (opcode == 7'b0010011) & (func3 == 3'b110); // ori
    wire          i_andi  = (opcode == 7'b0010011) & (func3 == 3'b111); // andi
    wire          i_slli  = (opcode == 7'b0010011) & (func3 == 3'b001) & (func7 == 7'b0000000); // slli
    wire          i_srli  = (opcode == 7'b0010011) & (func3 == 3'b101) & (func7 == 7'b0000000); // srli
    wire          i_srai  = (opcode == 7'b0010011) & (func3 == 3'b101) & (func7 == 7'b0100000); // srai
    wire          i_add   = (opcode == 7'b0110011) & (func3 == 3'b000) & (func7 == 7'b0000000); // add
    wire          i_sub   = (opcode == 7'b0110011) & (func3 == 3'b000) & (func7 == 7'b0100000); // sub
    wire          i_sll   = (opcode == 7'b0110011) & (func3 == 3'b001) & (func7 == 7'b0000000); // sll
    wire          i_slt   = (opcode == 7'b0110011) & (func3 == 3'b010) & (func7 == 7'b0000000); // slt
    wire          i_sltu  = (opcode == 7'b0110011) & (func3 == 3'b011) & (func7 == 7'b0000000); // sltu
    wire          i_xor   = (opcode == 7'b0110011) & (func3 == 3'b100) & (func7 == 7'b0000000); // xor
    wire          i_srl   = (opcode == 7'b0110011) & (func3 == 3'b101) & (func7 == 7'b0000000); // srl
    wire          i_sra   = (opcode == 7'b0110011) & (func3 == 3'b101) & (func7 == 7'b0100000); // sra
    wire          i_or    = (opcode == 7'b0110011) & (func3 == 3'b110) & (func7 == 7'b0000000); // or 
    wire          i_and   = (opcode == 7'b0110011) & (func3 == 3'b111) & (func7 == 7'b0000000); // and

	assign inst_decode = {i_and,i_or,i_sra,i_srl,i_xor,i_sltu,i_slt,i_sll,i_sub,i_add,i_srai,i_srli,i_slli,i_andi,i_ori,i_xori,i_sltiu,i_slti,i_addi,i_sw,i_sh,i_sb,i_lhu,i_lbu,i_lw,i_lh,i_lb,i_bgeu,i_bltu,i_bge,i_blt,i_bne,i_beq,i_jalr,i_jal,i_lui,i_auipc};
	
	// branch offset            31:13          12      11       10:5         4:1     0
    wire   [31:0] broffset  = {{19{sign}},inst[31],inst[7],inst[30:25],inst[11:8],1'b0};   // beq, bne,  blt,  bge,   bltu, bgeu
    wire   [31:0] simm      = {{20{sign}},inst[31:20]};                                    // lw,  addi, slti, sltiu, xori, ori,  andi
    wire   [31:0] jroffset  = {{20{sign}},inst[31:21],1'b0};                               // jalr
    wire   [31:0] stimm     = {{20{sign}},inst[31:25],inst[11:7]};                         // sw
    wire   [31:0] uimm      = {inst[31:12],12'h0};                                         // lui, auipc
    wire   [31:0] jaloffset = {{11{sign}},inst[31],inst[19:12],inst[20],inst[30:21],1'b0}; // jal
    // jal target               31:21          20       19:12       11       10:1      0


	//determaine which  extended immediate number to putout 
	//shift already been done
    wire	[5:0] outselect = {i_beq|i_bne|i_blt|i_bge|i_bltu|i_bgeu, i_lw|i_addi|i_slti|i_sltiu|i_xori|i_ori|i_andi, i_jalr, i_sw, i_lui|i_auipc, i_jal}; 

	always @(*)
	case (outselect)
		6'b100000: imm_out = broffset;
		6'b010000: imm_out = simm;
		6'b001000: imm_out = jroffset;
		6'b000100: imm_out = stimm;
		6'b000010: imm_out = uimm;
		6'b000001: imm_out = jaloffset;
		default: ;
	endcase

endmodule
