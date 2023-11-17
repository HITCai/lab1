`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/08 20:15:56
// Design Name: 
// Module Name: Zero
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


module Zero(
    input [31:0] data,
    output reg zero
    );

    initial begin
        zero <= 0;
    end

    always@(*)begin
        zero <= (data == 32'h00000000)? 1: 0;
    end

endmodule
