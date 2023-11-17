`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 22:59:09
// Design Name: 
// Module Name: IF_ID
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


module IF_ID(
        input clk,
        input stop,
        input [31:0] cpc,
        output reg [31:0] outpc,
        input resetn,
        input [31:0] IF_npc,
        input [31:0] IF_ir,
        output reg [31:0] ID_npc,
        output reg [31:0] ID_ir
    );

    always @(posedge clk or negedge resetn) begin
    if(!stop)begin
        if(!resetn) begin
        outpc <= 32'h00000000;
        ID_ir <= 32'h00000000;
        ID_npc <= 32'h00000000;
        outpc <= 32'h00000000;
        end
        else if(IF_ir == 0) begin
            ID_ir <= 32'h00000000;
            ID_npc <= 32'h00000000;
            outpc <= cpc;
        end
        else begin
            outpc <= cpc;
            ID_ir <= IF_ir;
            ID_npc <= IF_npc;
        end
    end
    end

endmodule
