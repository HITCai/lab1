`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 23:20:42
// Design Name: 
// Module Name: Decoder
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


module Decoder(
    input resetn,
    input [31:0] IR,
    output reg [5:0] op,
    output reg [5:0] func,
    output reg [4:0] rs,
    output reg [4:0] rd,
    output reg [4:0] rt,
    output reg [4:0] base,
    output reg [15:0] offset,
    output reg [4:0] sa,
    output reg [25:0] instr_index
    );

    always @(*) begin
        if(!resetn)begin
        op <= 0;
        func <= 0;
        rs <= 0;
        rt <= 0;
        rd <= 0;
        base <= 0;
        offset <= 0;
        sa <= 0;
        instr_index <= 0;
        end
        else begin
        op <= IR[5:0];
        func <= IR[31:26];
        rs <= IR[25:21];
        rt <= IR[20:16];
        rd <= IR[15:11];
        base <= IR[25:21];
        offset <= IR[15:0];
        sa <= IR[10:6];
        instr_index <= IR[25:0];
    end
    end
endmodule
