`timescale 1ns / 1ps
// `define INS_FILE_PATH "E:\\Xlinx_project\\lab_1\\lab_1.data\\base_inst_data"
`define INS_FILE_PATH "C:/Users/caixuegang/Desktop/计算机体系结构实验/lab_1/lab_1.data/additional_inst_data1"
// `define INS_FILE_PATH "E:\\Xlinx_project\\lab_1\\lab_1.data\\additional_inst_data2"


module IMEM(
    input         clk      ,//鏃堕挓淇″彿
    input  [7:0]  imem_addr ,//閫夊畾瀛樺偍鍦板潃
    output [31:0]  imem_rdata//璇诲嚭鐨勬寚浠?
);
    parameter ADDR = 8 ;//鍦板潃瀹藉害
    parameter NUMB = 1<<ADDR;//瀵勫瓨鍣ㄤ釜鏁?
    parameter SIZE = 32;//瀵勫瓨鍣ㄦ暟鎹綅瀹?
    wire [7:0] addr;
    assign addr = (imem_addr % 4 == 0)? imem_addr>>2 : 8'b0;
    reg [SIZE-1:0] IMEM [0:NUMB-1];//瀛樺偍鍣ㄥ爢

    initial begin//鍒濆鍖栧瘎瀛樺櫒
    $readmemh(`INS_FILE_PATH , IMEM);
    end

    // always @(posedge clk) begin //鏍规嵁鏃堕挓淇″彿鍐冲畾鍐欏叆锛堜笂鍗囨部鍐欏叆锛?
    //     imem_rdata <= IMEM[addr];
    // end
    assign imem_rdata = IMEM[addr];
    
endmodule
