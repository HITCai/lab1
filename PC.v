`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/30 22:40:35
// Design Name: 
// Module Name: PC
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


module PC(
    input clk,
    input wire stop,
    input [31:0] NPC,
    input wire resetn,
    output reg [31:0] PC
    );

    always @(posedge clk or negedge resetn)begin
    if(!stop) begin
        if (!resetn) PC <= 32'h00000000;
        else PC <= NPC;
    end
    end  

endmodule
