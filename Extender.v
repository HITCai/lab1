`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/01 20:24:18
// Design Name: 
// Module Name: Extender
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


module Extender(
    input wire [15:0] Immin,
    output wire [31:0] Immout
    );

    assign Immout = (Immin[15])?{16'hffff,Immin[15:0]}:{16'h0,Immin[15:0]};
    
endmodule
