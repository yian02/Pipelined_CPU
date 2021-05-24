module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

Control Control(
    .Op_i       (Instruction_Memory.instr_o[6:0]),
    .ALUOp_o    (),
    .ALUSrc_o   (),
    .RegWrite_o ()
);

Adder Add_PC(
    .data1_in   (PC.pc_o),
    .data2_in   (32'd4),
    .data_o     ()
);

PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (),
    .PCWrite_i (1'b1)// ###########must remove#############

);

Instruction_Memory Instruction_Memory(
    .addr_i     (PC.pc_o), 
    .instr_o    ()
);

Registers Registers(
    .clk_i      (clk_i),
    .RS1addr_i  (IF_ID.instruction_o [19:15]),
    .RS2addr_i  (IF_ID.instruction_o [24:20]),
    .RDaddr_i   (IF_ID.instruction_o [11:7]), 
    .RDdata_i   (MUX_MemtoReg.data_o), // not done with pipeline
    .RegWrite_i (Control.RegWrite_o), // not done with pipeline
    .RS1data_o   (), 
    .RS2data_o   () 
);

MUX32 MUX_ALUSrc(
    .data1_i    (Registers.RS2data_o),
    .data2_i    (Sign_Extend.data_o),
    .select_i   (Control.ALUSrc_o),
    .data_o     ()
);

MUX32 MUX_MemtoReg(
    .data1_i    (ALU.data_o),
    .data2_i    (Data_Memory.data_o),
    .select_i   (Control.MemtoReg_o),
    .data_o      ()
);

Sign_Extend Sign_Extend(
    .instruction_i     (IF_ID.instruction_o),
    .data_o     ()
);

ALU ALU(
    .data1_i    (Registers.RS1data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({Instruction_Memory.instr_o[31:25],Instruction_Memory.instr_o[14:12]}),
    .ALUOp_i    (Control.ALUOp_o),
    .ALUCtrl_o  ()
);

Data_Memory Data_Memory(
    .clk_i(clk_i), 
    .addr_i (ALU.data_o), 
    .MemRead_i (Control.MemRead_o),
    .MemWrite_i (Control.MemWrite_o),
    .data_i (Registers.RS2data_o),
    .data_o ()
);

IF_ID IF_ID(
    .clk_i (clk_i),
    .pc_i (PC.pc_o),
    .pc_o (),
    .instruction_i (Instruction_Memory.instr_o),
    .instruction_o ()

);

ID_EX ID_EX(
    .clk_i (clk_i),
    .pc_i (IF_ID.pc_o), 
    .pc_o (), 
    .RS1data_i ( Registers.RS1data_o ), 
    .RS1data_o(), 
    .RS2data_i (Registers.RS2data_o),
    .RS2data_o(),
    .RDaddr_i (IF_ID.instruction_o [11:7]), 
    .RDaddr_o (),
    .sign_ext_i (Sign_Extend.data_o), 
    .sign_ext_o()  
);

EX_MEM EX_MEM(
    .clk_i (clk_i),
    .pc_i (ID_EX.pc_o), // may change to another ALU output when implementing beq
    .pc_o (),
    .Zero_i (ALU.Zero_o),
    .Zero_o (),
    .ALUresult_i (ALU.data_o),
    .ALUresult_o (),
    .RS2data_i (ID_EX.RS2data_o),
    .RS2data_o (),
    .RDaddr_i (ID_EX.RDaddr_o),
    .RDaddr_o ()
);

MEM_WB MEM_WB(
    .RDaddr_i (EX_MEM.RDaddr_o),
    .RDaddr_o (),
    .ALUresult_i (EX_MEM.ALUresult_o),
    .ALUresult_o (),
    .MEMdata_i (Data_Memory.data_o),
    .MEMdata_o ()
);



endmodule