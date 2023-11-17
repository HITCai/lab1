`timescale 1ns / 1ps
`define REG_FILE_PATH "C:/Users/caixuegang/Desktop/�������ϵ�ṹʵ��/lab_1/lab_1.data/base_reg_data"

module Regfile(
    input clk,//时钟信号
    input [4:0] raddr1,//寄存器堆读地�?1
    output [31:0] rdata1,//返回数据1
    input [4:0] raddr2,//寄存器堆读地�?2
    output [31:0] rdata2,//返回数据2
    input we,//写使�?
    input [4:0] waddr,//写地�?
    input [31:0] wdata//写数�?
    );
    
    parameter ADDR = 5 ;//地址宽度
    parameter NUMB = 1<<ADDR;//寄存器个�?
    parameter SIZE = 32;//寄存器数据位�?

    reg [SIZE-1:0] Reg_files [0:NUMB-1];//寄存器堆

    initial begin//初始化寄存器
    $readmemh(`REG_FILE_PATH , Reg_files);
    end

    always @(negedge clk) begin
        if(we) Reg_files[waddr] <= wdata;//如果使能变化且到达时钟的上升�?
    end
    
    assign  rdata1 = Reg_files[raddr1];
    assign  rdata2 = Reg_files[raddr2];

endmodule

// module Regfile(
//     input clk,//时钟信号
//     input [4:0] raddr1,//寄存器堆读地�?1
//     output [31:0] rdata1,//返回数据1
//     input [4:0] raddr2,//寄存器堆读地�?2
//     output [31:0] rdata2,//返回数据2
//     input we,//写使�?
//     input [4:0]waddr,//写地�?
//     input [31:0]wdata//写数�?
//     );
//     parameter ADDR = 5 ;//地址宽度
//     parameter NUMB = 1<<ADDR;//寄存器个�?
//     parameter SIZE = 32;//寄存器数据位�?

//     reg [SIZE-1:0] Reg_files [0:NUMB-1];//寄存器堆

//     integer i = 0;
//     initial begin//初始化寄存器
//         repeat(32) begin
//             Reg_files[i]<=0;
//             i=i+1;
//     end
//     end

//     always @(posedge clk) begin
//         if(we) Reg_files[waddr] <= wdata;//如果使能变化且到达时钟的上升�?
//     end

//     assign rdata1 = Reg_files[raddr1];
//     assign rdata2 = Reg_files[raddr2];
// endmodule
