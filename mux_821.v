`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/06 20:19:06
// Design Name: 
// Module Name: mux_821
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


module mux_821(
    input [31:0] data1,
    input [31:0] data2,
    input [31:0] data3,
    input [31:0] data4,
    input [31:0] data5,
    input [31:0] data6,
    input [31:0] data7,
    input [31:0] data8,
    input [2:0] index,
    output [31:0] result
    );

    assign result = (index == 3'b000) ? data1 :
                    (index == 3'b001) ? data2 :
                    (index == 3'b010) ? data3 :
                    (index == 3'b011) ? data4 :
                    (index == 3'b100) ? data5 :
                    (index == 3'b101) ? data6 :
                    (index == 3'b110) ? data7 :
                                        data8 ;
endmodule
