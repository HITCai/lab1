`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 22:59:09
// Design Name: 
// Module Name: ID_EX
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


module ID_EX(
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
        //接收CU的输入
        input wmem,
        input wreg,
        input [4:0] aluc,
        input [1:0] m2reg,
        input [2:0] asourse,
        input [2:0] bsourse,

        //CU数值传递
        output reg outwmem,
        output reg outwreg,
        output reg [4:0] outaluc,
        output reg [1:0] outm2reg,
        output reg [2:0] outasourse,
        output reg [2:0] outbsourse,

        //交给ALU的参数        
        input [31:0] ID_ra,
        input [31:0] ID_rb,
        input [31:0] ID_Imm,
        output [31:0] EX_ra,
        output [31:0] EX_rb,
        output [31:0] EX_Imm,

        //决定写入的地址
        input [4:0] ID_rn,
        output reg [4:0] EX_rn,

        //接收IR
        input [31:0] ID_inst,
        output [31:0] EX_inst
    );

    Container ID_EX_IR(
        .resetn(resetn),
        .in(ID_inst),
        .out(EX_inst),
        .clk(clk)
    );

    Container Imm(
        .resetn(resetn),
        .in(ID_Imm),
        .out(EX_Imm),
        .clk(clk)
    );

    Container A(
        .resetn(resetn),
        .in(ID_ra),
        .out(EX_ra),
        .clk(clk)
    );

    Container B(
        .resetn(resetn),
        .in(ID_rb),
        .out(EX_rb),
        .clk(clk)
    );

    // always@(*) begin
    // end

    always @(posedge clk) begin
        if(!resetn)begin
        outpc <= cpc;
        EX_rn <= 32'h00000000;
        outwmem <= 32'h00000000;
        outwreg <= 32'h00000000;
        outaluc <= 32'h00000000;
        outm2reg <= 32'h00000000;
        outasourse <= 0;
        outbsourse <= 0;
        npcout <= 32'h00000000;
        bpcout <= 32'h00000000;
        outpcsourse <= 0;
        end
        else if (ID_inst == 32'h00000000) begin
        EX_rn <= 5'b00000;
        outwmem <= 32'h00000000;
        outwreg <= 32'h00000000;
        outaluc <= 6'b000000;
        outm2reg <= 0;
        outasourse <= 0;
        outbsourse <= 0;
        npcout <= 32'h00000000;
        outpc <= cpc;
        bpcout <= bpc;
        // outpcsourse <= 0;
        end
        else begin
        outpcsourse <= pcsourse;
        EX_rn <= ID_rn;
        outwmem <= wmem;
        outwreg <= wreg;
        outaluc <= aluc;
        outm2reg <= m2reg;
        outasourse <= asourse;
        outbsourse <= bsourse;
        npcout <= npc;
        bpcout <= bpc;
        outpc <= cpc;
    end
    end

endmodule
