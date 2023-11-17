`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 22:59:09
// Design Name: 
// Module Name: MEM_WB
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

// 按照OP分类
`define Add 6'b100000
`define Sub 6'b100010
`define And 6'b100100
`define Or 6'b100101
`define Xor 6'b100110
`define Slt 6'b101010
`define Movz 6'b001010
`define Sll 6'b000000

//不同的Func
`define Cal 6'b000000
`define Sw 6'b101011
`define Lw 6'b100011
`define Bne 6'b000101
`define J 6'000010

module MEM_WB(
        input clk,
        input resetn,
        input [31:0] cpc,
        output reg [31:0] outpc,
        input [1:0] pcsourse,
        output reg [1:0] outpcsourse,
        input [31:0] npc,
        input [31:0] bpc,
        output reg [31:0] npcout,
        output reg [31:0] bpcout,

        //CU控制输入
        input wreg,
        input [1:0] m2reg,
        output reg outwreg,
        output reg [1:0] outm2reg,

        //ALU结果传递
        input [31:0] aluout,
        output [31:0] out_aluout,

        //MEM结果传递
        input [31:0] ldm,
        output [31:0] outldm,

        //rn传递
        input [4:0] MEM_rn,
        output reg [4:0] WB_rn,

        //INSTRUCTION传递
        input [31:0] MEM_inst,
        output [31:0] WB_inst,

        //b
        input [31:0] MEM_rb,
        output reg [31:0] WB_rb
    );

    Container ALUout(
        .in(aluout),
        .out(out_aluout),
        .clk(clk),
        .resetn(resetn)
    );

    Container MEM_WB_IR(
        .in(MEM_inst),
        .out(WB_inst),
        .clk(clk),
        .resetn(resetn)
    );

    Container LMD(
        .in(ldm),
        .out(outldm),
        .clk(clk),
        .resetn(resetn)
    );

    // always@(*) begin
    // end

    always @(posedge clk or negedge resetn) begin
        if(!resetn)begin
        outpcsourse <= 32'h00000000;
        npcout <= 32'h00000000;
        bpcout <= 32'h00000000;
        outm2reg <= 0;
        outwreg <= 0;
        WB_rn <= 5'b00000;
        WB_rb <= 32'h00000000;
        outpc <= 32'h00000000;
        end
        else if (MEM_inst == 32'h00000000) begin
        outpcsourse <= 0;
        npcout <= 32'h00000000;
        outm2reg <= 0;
        outwreg <= 0;
        WB_rn <= 5'b00000;
        WB_rb <= 32'h00000000;
        outpc <= 32'h00000000;
        bpcout <= bpc;
        outpc <= cpc;
        end
        else begin
        // if(MEM_rb != 0 && MEM_inst[31:26] == `Cal && MEM_inst[5:0] == `Movz)begin
        //     outwreg <= 1;
        // end
        // else 
        // outwreg <= 0;
        WB_rb <= MEM_rb;
        outpcsourse <= pcsourse;
        bpcout <= bpc;
        npcout <= npc;
        outm2reg <= m2reg;
        outwreg <= wreg;
        WB_rn <= MEM_rn;
        outpc <= cpc;
        end
    end

endmodule
