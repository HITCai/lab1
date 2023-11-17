`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/31 18:07:06
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`define ADD     5'b00001
// 加
`define ADDI    5'b00010
// 加进位
`define SUB     5'b00011
// 减
`define SUBI    5'b00100
//减进位
`define RSUB    5'b00101
//反减
`define RSUBI   5'b00110
//反减再减进位
`define GA      5'b00111
//赋值为A
`define GB      5'b01000
//赋值为B
`define NEGA    5'b01001
//A取反
`define NEGB    5'b01010
//B取反
`define OR      5'b01011
//或
`define AND     5'b01100
//与
`define XNOR    5'b01101
//同或
`define XOR     5'b01110
//异或
`define NAND    5'b01111
//与取反
`define ZERO    5'b10000
//置零
`define SLT     5'b10001
//小于
`define SLL     5'b10010
//左移
`define PC      5'b10011
//更新PC

//定义十六种操作

module ALU (
    input  [31:0]   A   ,
    input  [31:0]   B   ,
    input           Cin ,
    input  [4:0]    Card,
    output [31:0]   F   ,
    output          Cout,
    output          Zero
);
    wire [32:0]    Final; 
    wire [31:0]    add_result;
    wire [31:0]    addi_result;
    wire [31:0]    sub_result;
    wire [31:0]    subi_result;
    wire [31:0]    rsub_result;
    wire [31:0]    rsubi_result;
    wire [31:0]    ga_result;
    wire [31:0]    gb_result;
    wire [31:0]    nega_result;
    wire [31:0]    negb_result;
    wire [31:0]    or_result;
    wire [31:0]    and_result;
    wire [31:0]    xnor_result;
    wire [31:0]    xor_result;
    wire [31:0]    nand_result;
    wire [31:0]    zero_result;
    wire [31:0]    slt_result;
    wire [31:0]    sll_result;
    wire [31:0]    pc_result;
    
    // 定义运算
    assign add_result   = A + B;
    assign addi_result  = A + B + Cin;
    assign sub_result   = A - B;
    assign subi_result  = A - B - Cin;
    assign rsub_result  = B - A;
    assign rsubi_result = B - A - Cin;
    assign ga_result    = A;
    assign gb_result    = B;
    
    // 定义逻辑计算
    assign nega_result  = ~A;
    assign negb_result  = ~B;
    assign or_result    = A | B;
    assign and_result   = A & B;
    assign xnor_result  = ~(A ^ B);
    assign xor_result   = A ^ B;
    assign nand_result  = ~(A & B);
    assign zero_result  = 32'b0;
    assign slt_result   = A<B ? 1:0;
    assign sll_result   = B << A;
    assign pc_result    = A + (B << 2);
    
    //定义操作码选择
    assign Final   =({32{Card == `ADD}}    & add_result)    |
                    ({32{Card == `ADDI}}   & addi_result)   |
                    ({32{Card == `SUB}}    & sub_result)    |
                    ({32{Card == `SUBI}}   & subi_result)   |
                    ({32{Card == `RSUB}}   & rsub_result)   |
                    ({32{Card == `RSUBI}}  & rsubi_result)  |
                    ({32{Card == `GA}}     & ga_result)     |
                    ({32{Card == `GB}}     & gb_result)     |
                    ({32{Card == `NEGA}}   & nega_result)   |
                    ({32{Card == `NEGB}}   & negb_result)   |
                    ({32{Card == `OR}}     & or_result)     |
                    ({32{Card == `AND}}    & and_result)    |
                    ({32{Card == `XNOR}}   & xnor_result)   |
                    ({32{Card == `XOR}}    & xor_result)    |
                    ({32{Card == `NAND}}   & nand_result)   |
                    ({32{Card == `ZERO}}   & zero_result)   |
                    ({32{Card == `SLT}}   & slt_result)     |
                    ({32{Card == `SLL}}   & sll_result)     |
                    ({32{Card == `PC}}   & pc_result);

    // 定义进位和零符号位
    assign Cout = Final[32];
    assign F = Final[31:0];
    assign Zero = (F == 32'b0);

endmodule
