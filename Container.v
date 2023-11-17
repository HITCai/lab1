`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 23:04:51
// Design Name: 
// Module Name: Container
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


module Container(
    input wire [31:0] in,
    input clk,
    input resetn,
    output reg [31:0] out
    );
    
    always @(posedge clk) begin
    if(!resetn) out <= 32'h00000000;
    else out <= in;
    end

endmodule
