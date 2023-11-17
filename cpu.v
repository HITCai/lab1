`timescale 1ns / 1ps

`define Add 6'b100000
`define Sub 6'b100010
`define And 6'b100100
`define Or 6'b100101
`define Xor 6'b100110
`define Slt 6'b101010
`define Movz 6'b001010
`define Sll 6'b000000

`define Cal 6'b000000
`define Sw 6'b101011
`define Lw 6'b100011
`define Bne 6'b000101
`define J 6'000010


module cpu(
    input           clk,           // clock, 100MHz
    input           resetn,        // active low

    // debug signals
    output [31:0]   debug_wb_pc,    // 当前正在执行指令�? PC
    output          debug_wb_rf_wen, // 当前通用寄存器组的写使能信号
    output [4:0]    debug_wb_rf_addr,// 当前通用寄存器组写回的寄存器编号
    output [31:0]   debug_wb_rf_wdata // 当前指令�?要写回的数据
    );


    
wire [31:0] bpc; //作为跳转的内�?
wire [31:0] npc; // chosen npc
wire [31:0] pc; // chosen pc (same as npc)
wire [1:0]  pcsourse ; // pc choice
wire        active; // 标识Locker是否启动

wire [31:0] if_pc4; // answer for pc add 4
wire [31:0] if_inst; // taken instruction

wire [31:0] id_pc4; // same as if_pc4
wire [31:0] id_inst; // same as if_inst
wire [4:0]  id_rs; // as the addr of A
wire [4:0]  id_rt; // as the addr of B or detination
wire [4:0]  id_rd; // as the addr of destination
wire [15:0] id_offset; // as the offset of load and store function
wire [4:0]  id_base; // as the base addr
wire [25:0] id_index; // as the jump pcsourse
wire        id_wmem ; // write memery access
wire        id_wreg ; // write regfile access
wire [4:0]  id_aluc ; // alu function choice
wire [1:0]  id_m2reg; // write back data choice
wire [1:0]  id_regaddr; // write back reg address choice
wire [2:0]  id_asourse; // A data choice
wire [2:0]  id_bsourse; // B data choice
wire [4:0]  id_rn; // the addr of chosen reg
wire [31:0] id_ra; // 代表的是读出的A寄存器中的�??
wire [31:0] id_rb; // 代表的是读出的B寄存器中的�??
wire        id_equal; // 代表的是A和B是否相等
wire [5:0]  id_op; // 作为CU的op输入
wire [5:0]  id_func; // 作为CU的func输入
wire [4:0]  id_sa; // 作为CU的sa输入
wire [31:0] id_imm; // 作为立即数输�?
wire [31:0] id_cpc;// 传�?�ID段的PC�?
wire        id_zero;// 判断这个时�?�的B的�?�是否为0
wire [31:0] id_chosen_inst;// 向ID段内插入的指�?


wire        ex_zero ; // get the Zero flag in ALU
wire        ex_wmem ; // write memery access
wire        ex_wreg ; // write regfile access
wire [4:0]  ex_aluc ; // alu function choice
wire [1:0]  ex_m2reg; // write back data choice
wire [2:0]  ex_asourse; // A data choice (for base)
wire [2:0]  ex_bsourse; // B data choice (for base)
wire [4:0]  ex_rn; // the addr of chosen reg
wire [31:0] ex_ra; //代表的是读出的A寄存器中的�??
wire [31:0] ex_rb; //代表的是读出的B寄存器中的�??
wire [31:0] ex_inst; // 代表的是指令instruction
wire [31:0] ex_imm; // 代表Imm的结�?
wire [31:0] ex_data1; // 代表ALU的第�?个输�?
wire [31:0] ex_data2; // 代表ALU的第二个输入
wire [31:0] ex_aluout; // 代表ALU输出
wire [1:0]  ex_rbsourse;  // 代表b的内容�?�择�?
wire [2:0]  ex_a_sel; // 代表a的�?�择器�?�择使能
wire [2:0]  ex_b_sel; //代表b的�?�择器�?�择使能
wire [31:0] ex_chosen_rb; //代表的是选择的B的数�?
wire [31:0] ex_bpc;//传�?�跳转指�?
wire [31:0] ex_pc4;//传�?�PC+4
wire [ 1:0] ex_pcsourse;// PC的�?�择部分
wire [31:0] ex_cpc;// 用于存储当前段内的PC


wire        mem_wreg; // 传�?�的写寄存器使能
wire [1:0]  mem_m2reg; // 传�?�的写入数据选择
wire        mem_wmem; // 传�?�的写存储器使能
wire [31:0] mem_aluout; // 传�?�的是alu的计算结�?
wire [4:0]  mem_rn; //传输的是写入寄存器的地址
wire [31:0] mem_inst; //传输的是mem段的指令
wire [31:0] mem_bsourse; //传输的是在rt地址位置的数
wire [31:0] mem_memdata; //传输的是mem段读出的数据 
wire [31:0] mem_pc4; // 代表PC+4的存�? 
wire [31:0] mem_bpc; // 代表的是跳转的指令PC
wire [1:0]  mem_pcsourse; // 代表的是选择的pcsourse
wire [31:0] mem_cpc; 


wire [1:0]  wb_m2reg; // 传�?�的写入数据选择
wire [31:0] wb_aluout; // 传�?�的是alu的计算结�?
wire [4:0]  wb_rn; //代表写回的时候使用的地址
wire [31:0] wb_data; //代表写回的时候使用的数据
wire        wb_wreg; //代表是否能够写回Regfile的使�?
wire [31:0] wb_memdata;
wire [31:0] wb_pc4;
wire [31:0] wb_bpc;
wire [1:0]  wb_pcsourse;
wire [31:0] wb_inst;
wire [31:0] wb_cpc;
wire [31:0] wb_bsourse;



assign debug_wb_pc = wb_cpc;
assign debug_wb_rf_wen = wb_wreg;
assign debug_wb_rf_addr = wb_rn;
assign debug_wb_rf_wdata = wb_data;


PC mypc(
    .stop(stop),
    .clk(clk),
    .NPC(npc),
    .resetn(resetn),
    .PC(pc)
);

add4 myadd4(
    .data(pc),
    .result(if_pc4)
);

IMEM myInstRom(
    .clk(clk),
    .imem_addr(pc[7:0]),
    .imem_rdata(if_inst)
);

IF_ID myIF_ID(
    .cpc(pc),
    .outpc(id_cpc),
    .stop(stop),
    .clk(clk),
    .resetn(resetn),
    .IF_ir(if_inst),
    .IF_npc(if_pc4),
    .ID_npc(id_pc4),
    .ID_ir(id_inst)
);

Decoder mydecoder(
    .resetn(resetn),
    .IR(id_inst),
    .op(id_op),
    .func(id_func),
    .rs(id_rs),
    .rd(id_rd),
    .rt(id_rt),
    .base(id_base),
    .offset(id_offset),
    .sa(id_sa),
    .instr_index(id_index)
);

Cond mycond(
    .ra(id_ra),
    .rb(id_rb),
    .equal(id_equal)
);

// TODO 注意这里要修改一下判断条件，因为没有办法及时更新
Zero zero(
    .data(id_rb),
    .zero(id_zero)
);

Zero zero_change(
    .data(ex_chosen_rb),
    .zero(ex_zero)
);

CU myCU(
    .inst(id_inst),
    .resetn(resetn),
    .func(id_func),
    .op(id_op),
    .Zero(id_zero),
    .Equal(id_equal),
    .wmem(id_wmem),
    .wreg(id_wreg),
    .aluc(id_aluc),
    .PCsourse(pcsourse),
    .m2reg(id_m2reg),
    .regaddr(id_regaddr),
    .asourse(id_asourse),
    .bsourse(id_bsourse)
);

Extender myextender(
    .Immin(id_offset),
    .Immout(id_imm)
);

adder tobpc(
    .data1(id_imm),
    .data2(id_pc4),
    .result(bpc)
);

Regfile myregfile(
    .clk(clk),
    .raddr1(id_rs),
    .rdata1(id_ra),
    .raddr2(id_rt),
    .rdata2(id_rb),
    .we(wb_wreg),
    .waddr(wb_rn),
    .wdata(wb_data)
); 

ID_EX myID_EX(
    .cpc(id_cpc),
    .outpc(ex_cpc),
    .clk(clk),
    .resetn(resetn),
    .pcsourse(pcsourse),
    .outpcsourse(ex_pcsourse),
    .npc(id_pc4),
    .bpc(bpc),
    .npcout(ex_pc4),
    .bpcout(ex_bpc),
//接收CU的输�?
    .wmem(id_wmem),
    .wreg(id_wreg),
    .aluc(id_aluc),
    .m2reg(id_m2reg),
    .asourse(id_asourse),
    .bsourse(id_bsourse),

//CU的数值传�?
    .outwmem(ex_wmem),
    .outwreg(ex_wreg),
    .outaluc(ex_aluc),
    .outm2reg(ex_m2reg),
    .outasourse(ex_asourse),
    .outbsourse(ex_bsourse),

//交给ALU的参�?
    .ID_ra(id_ra),
    .ID_rb(id_rb),
    .ID_Imm(id_imm),
    .EX_ra(ex_ra),
    .EX_rb(ex_rb),
    .EX_Imm(ex_imm),

//传�?�的可写地址
    .ID_rn(id_rn),
    .EX_rn(ex_rn),

//IR
    .ID_inst(id_chosen_inst),
    .EX_inst(ex_inst)
);

// A �? B 的�?�择�?

// TODO 记得要再试试加上stop来管理每�?个暂�?

// TODO 这里加上Locker，注意管脚有没有错误 �?后再�?

// ALU的接口标�?

ALU myALU(
    .A(ex_data1),
    .B(ex_data2),
    .Cin(1'b0),
    .Card(ex_aluc),
    .Cout(),
    .F(ex_aluout),
    .Zero(ex_zero)
);



EX_MEM myEX_MEM(
    //PC跟踪
    .cpc(ex_cpc),
    .outpc(mem_cpc),


    .clk(clk),
    .resetn(resetn),
    .pcsourse(ex_pcsourse),
    .outpcsourse(mem_pcsourse),
    .npc(ex_pc4),
    .bpc(ex_bpc),
    .npcout(mem_pc4),
    .bpcout(mem_bpc),

    //CU的控制部�?
    .wreg(ex_wreg),
    .m2reg(ex_m2reg),
    .wmem(ex_wmem),
    .outwreg(mem_wreg),
    .outm2reg(mem_m2reg),
    .outwmem(mem_wmem),

    //ALU输出部分
    .aluout(ex_aluout),
    .out_aluout(mem_aluout),

    //数�?�传递部�?
    // .EX_ra(ex_ra),
    .EX_rb(ex_chosen_rb),
    .EX_rn(ex_rn),
    .MEM_rn(mem_rn),
    .MEM_rb(mem_bsourse),
    // .MEM_ra(mem_asourse),

    //指令存储部分
    .EX_ir(ex_inst),
    .MEM_ir(mem_inst)
);



DMEM myDataMem(
        .clk(clk),
        .dmem_addr(mem_aluout[7:0]),
        .dmem_wdata(mem_bsourse),
        .dmem_wen(mem_wmem),
        .dmem_rdata(mem_memdata)
);


MEM_WB myMEM_WB(
    //PC跟踪
    .cpc(mem_cpc),
    .outpc(wb_cpc),
    
    .clk(clk),
    .resetn(resetn),
    .pcsourse(mem_pcsourse),
    .outpcsourse(wb_pcsourse),
    .npc(mem_pc4),
    .bpc(mem_bpc),
    .npcout(wb_pc4),
    .bpcout(wb_bpc),

    //CU控制输入
    .wreg(mem_wreg),
    .m2reg(mem_m2reg),
    .outwreg(wb_wreg),
    .outm2reg(wb_m2reg),

    // ALU结果传�??
    .aluout(mem_aluout),
    .out_aluout(wb_aluout),

    //MEM内容结果传�??
    .ldm(mem_memdata),
    .outldm(wb_memdata),


    //rn传�??
    .MEM_rn(mem_rn),
    .WB_rn(wb_rn),

    //Instruct传�??
    .MEM_inst(mem_inst),
    .WB_inst(wb_inst),

    .MEM_rb(mem_bsourse),
    .WB_rb(wb_bsourse)
);



// wire wreg_sel;
// wire [1:0] pcsourse_sel;

Locker myLocker(

    //接收�?有指�?
    .if_id_inst(id_inst),
    .id_ex_inst(ex_inst),
    .ex_mem_inst(mem_inst),
    .mem_wb_inst(wb_inst),

    //选择更新的B的数�?
    .ex_rbsourse(ex_rbsourse),
    .ex_mem_rb(mem_bsourse),
    .mem_wb_rb(wb_bsourse),

    //A的�?�择和B的�?�择控制
    .a_sel(ex_asourse),
    .b_sel(ex_bsourse),
    .asourse(ex_a_sel),
    .bsourse(ex_b_sel),

    //wreg选择,跳转选择
    // .wregsourse(),
    // .pcsourse(),

    //暂停控制
    .stop(stop),
    .id_inst(id_chosen_inst),

    //�?测是否在工作
    .active(active)
);

// all kinds of mux    
mux_421 Bget(
    .data1(ex_rb),
    .data2(mem_aluout),
    .data3(wb_data),
    .data4(0),
    .index(ex_rbsourse),
    .result(ex_chosen_rb)
);


mux_421 WBdata(
    .data1(wb_aluout),
    .data2(wb_memdata),
    .data3(32'b0),
    .data4(32'b0),
    .index(wb_m2reg),
    .result(wb_data)
);

mux_421_2 RegAddr(
    .data1(id_rd),
    .data2(id_rt),
    .data3(5'b0),
    .data4(5'b0),
    .result(id_rn),
    .index(id_regaddr)
);

mux_421 PCmux(
    .data1(if_pc4),
    .data2(mem_bpc),
    .data3({id_pc4[31:28], id_index[25:24] , id_index << 2}), //代表jpc
    .data4(32'b0),
    .index(mem_pcsourse),
    .result(npc)
);

mux_821 AsourseMux(
    .data1(ex_ra),
    .data2({27'b0,ex_inst[25:21]}),
    .data3({27'b0,ex_inst[10:6]}),
    .data4(mem_aluout),
    .data5(wb_aluout),
    .data6(wb_memdata),
    .data7(32'b0),
    .data8(32'b0),
    .index(ex_a_sel),
    .result(ex_data1)
);

mux_821 BsourseMux(
    .data1(ex_rb),
    .data2(ex_imm),
    .data3(mem_aluout),
    .data4(wb_aluout),
    .data5(wb_memdata),
    .data6(32'b0),
    .data7(32'b0),
    .data8(32'b0),
    .index(ex_b_sel),
    .result(ex_data2)
);




endmodule
