`timescale 1ns / 1ps
`define ADD     5'b00001// 加
`define ADDI    5'b00010// 加进位
`define SUB     5'b00011// 减
`define SUBI    5'b00100//减进位
`define RSUB    5'b00101//反减
`define RSUBI   5'b00110//反减再减进位
`define GA      5'b00111//赋值为A
`define GB      5'b01000//赋值为B
`define NEGA    5'b01001//A取反
`define NEGB    5'b01010//B取反
`define OR      5'b01011//或
`define AND     5'b01100//与
`define XNOR    5'b01101//同或
`define XOR     5'b01110//异或
`define NAND    5'b01111//与取反
`define ZERO    5'b10000//置零
`define SLT     5'b10001//小于
`define SLL     5'b10010//左移
`define PC      5'b10011//更新PC

module CU(
    input [31:0] inst,
    input resetn,
    input [5:0] func,
    input [5:0] op,
    input Zero,                 // 零标志位
    input Equal,
    output reg wmem,           // 存储器写使能
    output reg wreg,           // 寄存器写使能
    output reg [4:0] aluc,      // ALU功能码
    output reg [1:0] PCsourse,            // PC数据来源选择
    output reg [1:0] m2reg,       // 寄存器文件数据来源选择
    output reg [1:0] regaddr,  // 寄存器文件地址来源选择
    output reg [2:0] asourse,          // ALU输入A来源选择
    output reg [2:0] bsourse           // ALU输入B来源选择
    );

    reg [5:0] Op;
    reg [5:0] Func;
    

    always @(*) begin
        if(!resetn) begin
        Func <= 6'b111111;
        Op <= 6'b000000;
        end
        else if (inst == 32'h00000000) begin
        Func <= 6'b111111;
        Op <= 6'b000000;
        end
        else begin
        Func <= func;
        Op <= op;
        end
        case (Func)
            6'b000000: begin
                case (Op)
                    6'b100000: begin // 加法操作
                        wmem <= 0;            // 存储器写禁用
                        wreg <= 1;            // 寄存器写使能
                        aluc <= `ADD;             // ALU功能码为加法
                        PCsourse <= 0;             // PC数据来源：NPC
                        m2reg <= 0;        // 寄存器文件数据来源：ALU
                        regaddr <= 0;   // 寄存器文件地址来源：目标寄存器（rd）
                        asourse <= 0;           // ALU输入A来源：寄存器A
                        bsourse <= 0;           // ALU输入B来源：寄存器B
                    end
                    6'b100010: begin // 减法操作
                        wmem <= 0;
                        wreg <= 1;
                        aluc <= `SUB;             // ALU功能码为减法
                        PCsourse <= 0;
                        m2reg <= 0;
                        regaddr <= 0;
                        asourse <= 0;
                        bsourse <= 0;
                    end 
                    6'b100100: begin // 与操作
                        wmem <= 0;
                        wreg <= 1;
                        aluc <= `AND;
                        PCsourse <= 0;
                        m2reg <= 0;
                        regaddr <= 0;
                        asourse <= 0;
                        bsourse <= 0;
                    end
                    6'b100101: begin // 或操作
                        wmem <= 0;
                        wreg <= 1;
                        aluc <= `OR;
                        PCsourse <= 0;
                        m2reg <= 0;
                        regaddr <= 0;
                        asourse <= 0;
                        bsourse <= 0;
                    end
                    6'b100110: begin // 异或操作
                        wmem <= 0;
                        wreg <= 1;
                        aluc <= `XOR;
                        PCsourse <= 0;
                        m2reg <= 0;
                        regaddr <= 0;
                        asourse <= 0;
                        bsourse <= 0;
                    end
                    6'b101010: begin // SLT操作（设置小于）
                        wmem <= 0;
                        wreg <= 1;
                        aluc <= `SLT;
                        PCsourse <= 0;
                        m2reg <= 0;
                        regaddr <= 0;
                        asourse <= 0;
                        bsourse <= 0;
                    end
                    6'b001010: begin // MOVZ操作（如果为零则移动）
                        wmem <= 0;
                        wreg <= Zero;        // 如果零标志位为1，则寄存器写使能
                        aluc <= `GA;
                        PCsourse <= 0;
                        m2reg <= 0;       // 寄存器文件数据来源：寄存器A
                        regaddr <= 0;
                        asourse <= 0;
                        bsourse <= 0;
                    end
                    6'b000000: begin // SLL操作（逻辑左移）
                        wmem <= 0;
                        wreg <= 1;
                        aluc <= `SLL;
                        PCsourse <= 0;
                        m2reg <= 0;
                        regaddr <= 0;
                        asourse <= 2;          // ALU输入A来源：指令中的位移量（sa）
                        bsourse <= 0;          // ALU输入B来源：寄存器B
                    end
                    default: begin
                        wmem <= 0;            // 默认值
                        wreg <= 0;
                        aluc <= 0;
                        PCsourse <= 0;
                        m2reg <= 0;
                        regaddr <= 0;
                        asourse <= 0;
                        bsourse <= 0;
                    end
                endcase
            end 
            6'b101011: begin // SW操作（存储字）
                wmem <= 1;            // 存储器写使能
                wreg <= 0;
                aluc <= `ADD;      // ALU功能码用于地址计算
                PCsourse <= 0;
                m2reg <= 0;
                regaddr <= 1;             // 地址来源：寄存器rt
                asourse <= 1;            // ALU输入A来源：指令中的base部分
                bsourse <= 1;            // ALU输入B来源：寄存器Imm
            end
            6'b100011: begin // LW操作（加载字）
                wmem <= 0;
                wreg <= 1;
                aluc <= `ADD;      // ALU功能码用于地址计算
                PCsourse <= 0;
                m2reg <= 1;         // 寄存器文件数据来源：寄存器LMD
                regaddr <= 1;            // 地址来源：寄存器rt
                asourse <= 0;            // ALU输入A来源：指令中的base部分
                bsourse <= 1;            // ALU输入B来源：寄存器Imm
            end

            //这里需要改一下: 现在已经不需要使用ALU了

            6'b000101: begin // BNE操作（如果不相等则分支）
                wmem <= 0;
                wreg <= 0;
                aluc <= `PC;       // ALU功能码用于分支地址计算
                if(Equal == 1) PCsourse <= 0;
                else  PCsourse <= 1;
                m2reg <= 0;
                regaddr <= 0;
                asourse <= 6;            // ALU输入A来源：寄存器NPC
                bsourse <= 1;            // ALU输入B来源：寄存器Imm
            end

            6'b000010: begin // J操作（跳转）
                wmem <= 0;
                wreg <= 0;
                aluc <= 5'b00000;
                PCsourse <= 2;              // PC数据来源：无条件跳转
                m2reg <= 0;
                regaddr <= 0;
                asourse <= 2;
                bsourse <= 2;
            end
            default: begin
                wmem <= 0;            // 默认值
                wreg <= 0;
                aluc <= 0;
                PCsourse <= 0;
                m2reg <= 0;
                regaddr <= 0;
                asourse <= 0;
                bsourse <= 0;
            end
        endcase
    end
endmodule
