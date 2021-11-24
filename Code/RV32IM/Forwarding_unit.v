//
// RISC-V RV32I CPU Forwarding unit & MUXs
//
module risc_v_32_forward(a1,a2,a3,b1,b2,b3,idex_rs1,idex_rs2,exmem_wreg,exmem_rd,memwb_wreg,memwb_rd,a,b);
    
    input      [31:0] a1,a2,a3;                         //MUX1 inputs
    input      [31:0] b1,b2,b3;                         //MUX2 inputs
    input       [4:0] idex_rs1,idex_rs2;                //rs1,rs2
    input             exmem_wreg,memwb_wreg;            //write register
    input       [4:0] exmem_rd,memwb_rd;                //rd
    
    output reg [31:0] a,b;                              //output to alu/ex stage

    reg [1:0] forward_a;
    reg [1:0] forward_b;
    
    always @ (*) begin
        forward_a = 0;
        forward_b = 0;
        if (exmem_wreg && (exmem_rd != 0) && (exmem_rd == idex_rs1))                                                                forward_a = 2'b10;
        if (exmem_wreg && (exmem_rd != 0) && (exmem_rd == idex_rs2))                                                                forward_b = 2'b10;
        if (memwb_wreg && (memwb_rd != 0) && !(exmem_wreg && (exmem_rd != 0) && (exmem_rd == idex_rs1)) && (memwb_rd == idex_rs1))  forward_a = 2'b01;
        if (memwb_wreg && (memwb_rd != 0) && !(exmem_wreg && (exmem_rd != 0) && (exmem_rd == idex_rs2)) && (memwb_rd == idex_rs2))  forward_b = 2'b01;
    end
    
    //MUX1
    always @ (*) begin
        a = a1;
        case (forward_a)
            2'b00:  a = a1;
            2'b01:  a = a2;
            2'b10:  a = a3;
        endcase
    end
    
    //MUX2
    always @ (*) begin
        b = b1;
        case (forward_b)
            2'b00:  b = b1;
            2'b01:  b = b2;
            2'b10:  b = b3;
        endcase
    end
    
    
endmodule
