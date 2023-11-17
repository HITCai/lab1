`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/01 15:10:07
// Design Name: 
// Module Name: IMEM
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
// `define DATA_FILE_PATH "E:\\Xlinx_project\\lab_1\\lab_1.data\\base_data_data"
`define DATA_FILE_PATH "C:/Users/caixuegang/Desktop/�������ϵ�ṹʵ��/lab_1/lab_1.data/additional_data_data1"
// `define DATA_FILE_PATH "E:\\Xlinx_project\\lab_1\\lab_1.data\\additional_data_data2"



module DMEM(
    input         clk      ,//时钟信号
    input  [7:0]  dmem_addr ,//选定存储地址
    input  [31:0] dmem_wdata,//输入的数�?
    input         dmem_wen  ,//写使�?
    output [31:0] dmem_rdata//读出的指�?
);
    parameter ADDR = 8 ;//地址宽度
    parameter NUMB = 1<<ADDR;//寄存器个�?
    parameter SIZE = 32;//寄存器数据位�?
    wire [7:0] addr;

    assign addr = (dmem_addr % 4 == 0)? dmem_addr >> 2 : 8'b0;
    reg [SIZE-1:0] DMEM [0:NUMB-1];//存储器堆

    integer i = 0;
    initial begin//初始化寄存器
    $readmemh(`DATA_FILE_PATH , DMEM);
    end

    always @(posedge clk) begin
        if(dmem_wen) DMEM[addr] <= dmem_wdata;//如果写使能打�?就能�?里面写数�?
    end

    assign dmem_rdata = DMEM[addr];

    
endmodule
