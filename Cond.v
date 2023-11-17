`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/07 16:17:40
// Design Name: 
// Module Name: Cond
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


module Cond(
    input [31:0] ra,
    input [31:0] rb,
    output equal
    );

    assign equal = (ra == rb)? 0 : 1;

endmodule
