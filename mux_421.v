`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/01 22:43:20
// Design Name: 
// Module Name: mux_421
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


module mux_421(
    input [1:0] index, 
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [31:0] data4,
    output reg [31:0] result
    );

    reg [31:0] temp;
    
    always @(*)begin
        case(index)
            2'b00: temp = data1;
            2'b01: temp = data2;
            2'b10: temp = data3;
            default: temp = data4;
        endcase
    result <= temp;
    end

    
endmodule

