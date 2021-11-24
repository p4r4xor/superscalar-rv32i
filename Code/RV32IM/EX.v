//
// RISC-V RV32I CPU EX 
//

module risc_v_32_ex(pc,a,b,inst,inst_decode,imm_in,m_addr,d_t_mem,wreg,wmem,rmem,i_load,alu_out,next_pc,PCSrc);
    input  [31:0] inst;                                      // instruction
//  input  [31:0] d_f_mem;                                   // load data
    input  [31:0] pc;                                        // program counter
    input  [31:0] a;                                         // read_data1
    input  [31:0] b;                                         // read_data2
    input  [36:0] inst_decode;                               // instruction decode, if inst_decode == 1, means ex instruction is the corresponding inst
    input  [31:0] imm_in;                                    // immediate from ID
    output [31:0] m_addr;                                    // mem or i/o addr
    output [31:0] d_t_mem;                                   // store data
    output        wreg;                                      // write regfile 
    output        wmem;                                      // write memory
    output        rmem;                                      // read memory
    output        i_load;                                    // write to register file
    output [31:0] alu_out;                                   // alu output
//  output [31:0] mem_out;                                   // mem output
    output [31:0] next_pc;                                   // next pc
    output        PCSrc;                                     // pc MUX control signal

    // instruction format
    wire [6:0]    opcode = inst[6:0];   // 
    wire [2:0]    func3  = inst[14:12]; // 
    wire [6:0]    func7  = inst[31:25]; // 
    wire [4:0]    rd     = inst[11:7];  // 
    wire [4:0]    rs     = inst[19:15]; // = rs1
    wire [4:0]    rt     = inst[24:20]; // = rs2
    wire [4:0]    shamt  = inst[24:20]; // == rs2;    
    wire          sign   = inst[31];

    // instruction
    wire          i_auipc = inst_decode[0] ; // auipc
    wire          i_lui   = inst_decode[1] ; // lui
    wire          i_jal   = inst_decode[2] ; // jal
    wire          i_jalr  = inst_decode[3] ; // jalr
    wire          i_beq   = inst_decode[4] ; // beq
    wire          i_bne   = inst_decode[5] ; // bne
    wire          i_blt   = inst_decode[6] ; // blt
    wire          i_bge   = inst_decode[7] ; // bge
    wire          i_bltu  = inst_decode[8] ; // bltu
    wire          i_bgeu  = inst_decode[9] ; // bgeu
    wire          i_lb    = inst_decode[10]; // lb
    wire          i_lh    = inst_decode[11]; // lh
    wire          i_lw    = inst_decode[12]; // lw
    wire          i_lbu   = inst_decode[13]; // lbu
    wire          i_lhu   = inst_decode[14]; // lhu
    wire          i_sb    = inst_decode[15]; // sb
    wire          i_sh    = inst_decode[16]; // sh
    wire          i_sw    = inst_decode[17]; // sw
    wire          i_addi  = inst_decode[18]; // addi
    wire          i_slti  = inst_decode[19]; // slti
    wire          i_sltiu = inst_decode[20]; // sltiu
    wire          i_xori  = inst_decode[21]; // xori
    wire          i_ori   = inst_decode[22]; // ori
    wire          i_andi  = inst_decode[23]; // andi
    wire          i_slli  = inst_decode[24]; // slli
    wire          i_srli  = inst_decode[25]; // srli
    wire          i_srai  = inst_decode[26]; // srai
    wire          i_add   = inst_decode[27]; // add
    wire          i_sub   = inst_decode[28]; // sub
    wire          i_sll   = inst_decode[29]; // sll
    wire          i_slt   = inst_decode[30]; // slt
    wire          i_sltu  = inst_decode[31]; // sltu
    wire          i_xor   = inst_decode[32]; // xor
    wire          i_srl   = inst_decode[33]; // srl
    wire          i_sra   = inst_decode[34]; // sra
    wire          i_or    = inst_decode[35]; // or 
    wire          i_and   = inst_decode[36]; // and



    // output signals
    assign d_t_mem =  b;                                     // data to store

    // data written to register file
    assign i_load = i_lw | i_lb | i_lbu | i_lh | i_lhu;

    
    // control signals
    reg           wreg;                                      // write regfile
    reg           wmem;                                      // write memory
    reg           rmem;                                      // read memory
    reg   [31:0]  alu_out;                                   // alu output
//  reg   [31:0]  mem_out;                                   // mem output
    reg   [31:0]  m_addr;                                    // mem address
    reg   [31:0]  next_pc;                                   // next pc
    reg           PCSrc;                                     // pc MUX control 
    wire  [31:0]  pc_plus_4 = pc + 4;                        // pc + 4

    // control signals, will be combinational circuit
    always @(*) begin                                      // 30 instructions
        alu_out = 0;                                       // alu output
//      mem_out = 0;                                       // mem output
        m_addr  = 0;                                       // memory address
        wreg    = 0;                                       // write regfile
        wmem    = 0;                                       // write memory (sw)
        rmem    = 0;                                       // read  memory (lw)
        PCSrc   = 0;                                       // pc MUX control
        case (1'b1)
            i_add: begin                                   // add
                alu_out = a + b;
                wreg    = 1; end
            i_sub: begin                                   // sub
                alu_out = a - b;
                wreg    = 1; end
            i_and: begin                                   // and
                alu_out = a & b;
                wreg    = 1; end
            i_or: begin                                    // or
                alu_out = a | b;
                wreg    = 1; end
            i_xor: begin                                   // xor
                alu_out = a ^ b;
                wreg    = 1; end
            i_sll: begin                                   // sll
                alu_out = a << b[4:0];
                wreg    = 1; end
            i_srl: begin                                   // srl
                alu_out = a >> b[4:0];
                wreg    = 1; end
            i_sra: begin                                   // sra
                alu_out = $signed(a) >>> b[4:0];
                wreg    = 1; end
            i_slli: begin                                  // slli
                alu_out = a << shamt;
                wreg    = 1; end
            i_srli: begin                                  // srli
                alu_out = a >> shamt;
                wreg    = 1; end
            i_srai: begin                                  // srai
                alu_out = $signed(a) >>> shamt;
                wreg    = 1; end
            i_slt: begin                                   // slt
                if ($signed(a) < $signed(b)) 
                  alu_out = 1; end
            i_sltu: begin                                  // sltu
                if ({1'b0,a} < {1'b0,b}) 
                  alu_out = 1; end
            i_addi: begin                                  // addi
                alu_out = a + imm_in;
                wreg    = 1; end
            i_andi: begin                                  // andi
                alu_out = a & imm_in;
                wreg    = 1; end
            i_ori: begin                                   // ori
                alu_out = a | imm_in;
                wreg    = 1; end
            i_xori: begin                                  // xori
                alu_out = a ^ imm_in;
                wreg    = 1; end
            i_slti: begin                                  // slti
                if ($signed(a) < $signed(imm_in)) 
                  alu_out = 1; end
            i_sltiu: begin                                 // sltiu
                if ({1'b0,a} < {1'b0,imm_in}) 
                  alu_out = 1; end
            i_lw: begin                                    // lw
                alu_out = a + imm_in;
                m_addr  = {alu_out[31:2],2'b00};           // alu_out[1:0] != 0, exception
                rmem    = 1;
              //mem_out = d_f_mem;
                wreg    = 1; end
            i_lbu: begin                                   // lbu
                alu_out = a + imm_in;
                m_addr  = alu_out;
                rmem    = 1;
               /* case(m_addr[1:0])
                  2'b00: mem_out = {24'h0,d_f_mem[ 7: 0]};
                  2'b01: mem_out = {24'h0,d_f_mem[15: 8]};
                  2'b10: mem_out = {24'h0,d_f_mem[23:16]};
                  2'b11: mem_out = {24'h0,d_f_mem[31:24]};
                endcase*/
                wreg    = 1; end
            i_lb: begin                                    // lb
                alu_out = a + imm_in;
                m_addr  = alu_out;
                rmem    = 1;
                /*case(m_addr[1:0])
                  2'b00: mem_out = {{24{d_f_mem[ 7]}},d_f_mem[ 7: 0]};
                  2'b01: mem_out = {{24{d_f_mem[15]}},d_f_mem[15: 8]};
                  2'b10: mem_out = {{24{d_f_mem[23]}},d_f_mem[23:16]};
                  2'b11: mem_out = {{24{d_f_mem[31]}},d_f_mem[31:24]};
                endcase*/
                wreg    = 1; end
            i_lhu: begin                                   // lhu
                alu_out = a + imm_in;
                m_addr  = {alu_out[31:1],1'b0};            // alu_out[0] != 0, exception
                rmem    = 1;
                /*case(m_addr[1])
                  1'b0: mem_out = {16'h0,d_f_mem[15: 0]};
                  1'b1: mem_out = {16'h0,d_f_mem[31:16]};
                endcase*/
                wreg    = 1; end
            i_lh: begin                                    // lh
                alu_out = a + imm_in;
                m_addr  = {alu_out[31:1],1'b0};            // alu_out[0] != 0, exception
                rmem    = 1;
                /*case(m_addr[1])
                  1'b0: mem_out = {{16{d_f_mem[15]}},d_f_mem[15: 0]};
                  1'b1: mem_out = {{16{d_f_mem[31]}},d_f_mem[31:16]};
                endcase*/
                wreg    = 1; end
            i_sb: begin                                    // sb
                alu_out = a + imm_in;
                m_addr  = alu_out;
                wmem    = 1; end
            i_sh: begin                                    // sh
                alu_out = a + imm_in;
                m_addr  = {alu_out[31:1],1'b0};            // alu_out[0] != 0, exception
                wmem    = 1; end
            i_sw: begin                                    // sw
                alu_out = a + imm_in;
                m_addr  = {alu_out[31:2],2'b00};           // alu_out[1:0] != 0, exception
                wmem    = 1; end
            i_beq: begin                                   // beq
                if (a == b) begin
                  next_pc = pc + imm_in;
                  PCSrc   = 1; end end
            i_bne: begin                                   // bne
                if (a != b) begin
                  next_pc = pc + imm_in;
                  PCSrc   = 1; end end
            i_blt: begin                                   // blt
                if ($signed(a) < $signed(b)) begin
                  next_pc = pc + imm_in;
                  PCSrc   = 1; end end
            i_bge: begin                                   // bge
                if ($signed(a) >= $signed(b)) begin
                  next_pc = pc + imm_in;
                  PCSrc   = 1; end end
            i_bltu: begin                                  // bltu
                if ({1'b0,a} < {1'b0,b}) begin
                  next_pc = pc + imm_in;
                  PCSrc   = 1; end end
            i_bgeu: begin                                  // bgeu
                if ({1'b0,a} >= {1'b0,b}) begin
                  next_pc = pc + imm_in;
                  PCSrc   = 1; end end
            i_auipc: begin                                 // auipc
                alu_out = pc + imm_in;
                wreg    = 1; end
            i_lui: begin                                   // lui
                alu_out = imm_in;
                wreg    = 1; end
            i_jal: begin                                   // jal
                alu_out = pc_plus_4;
                wreg    = 1;
                next_pc = pc + imm_in;
                PCSrc   = 1; end
            i_jalr: begin                                  // jalr
                alu_out = pc_plus_4;
                wreg    = 1;
                next_pc = a + imm_in;
                PCSrc   = 1; end
            default: ;
        endcase
    end
endmodule