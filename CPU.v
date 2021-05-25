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
    .clk_i      (clk_i),
    .Op_i       (IF_ID.instruction_o[6:0]),
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
    .RDaddr_i   (MEM_WB.RDaddr_o), 
    .RDdata_i   (MUX_MemtoReg.data_o), // not done with pipeline
    .RegWrite_i (MEM_WB.RegWrite_o), // not done with pipeline
    .RS1data_o   (), 
    .RS2data_o   () 
);

MUX32 MUX_ALUSrc(
    .data1_i    (Forwarding_MUX_B.data_o),
    .data2_i    (ID_EX.sign_ext_o),
    .select_i   (ID_EX.ALUsrc_o),
    .data_o     ()
);

MUX32 MUX_MemtoReg(
    .data1_i    (MEM_WB.ALUresult_o),
    .data2_i    (MEM_WB.MEMdata_o),
    .select_i   (MEM_WB.MemtoReg_o),
    .data_o     ()
);

Sign_Extend Sign_Extend(
    .instruction_i     (IF_ID.instruction_o),
    .data_o     ()
);

ALU ALU(
    .data1_i    (Forwarding_MUX_A.data_o),
    .data2_i    (MUX_ALUSrc.data_o),
    .ALUCtrl_i  (ALU_Control.ALUCtrl_o),
    .data_o     (),
    .Zero_o     ()
);

ALU_Control ALU_Control(
    .funct_i    ({ID_EX.instruction_o[31:25],ID_EX.instruction_o[14:12]}),
    .ALUOp_i    (ID_EX.ALUOp_o),
    .ALUCtrl_o  ()
);

Data_Memory Data_Memory(
    .clk_i(clk_i), 
    .addr_i (EX_MEM.ALUresult_o), 
    .MemRead_i (EX_MEM.MemRead_o),
    .MemWrite_i (EX_MEM.MemWrite_o),
    .data_i (EX_MEM.RS2data_o),
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
    .sign_ext_o(), 
    //###Pipline Control Signals###
    //EXE stage control signals
    .ALUsrc_i (Control.ALUSrc_o),
    .ALUsrc_o (),
    .ALUOp_i (Control.ALUOp_o),
    .ALUOp_o (),
    .instruction_i (IF_ID.instruction_o),
    .instruction_o (),
    //MEM stage control signals
    .MemWrite_i (Control.MemWrite_o),
    .MemWrite_o (),
    .MemRead_i (Control.MemRead_o),
    .MemRead_o (),
    //WB stage control signals
    .MemtoReg_i (Control.MemtoReg_o),
    .MemtoReg_o (), 
    .RegWrite_i (Control.RegWrite_o),
    .RegWrite_o ()
);

EX_MEM EX_MEM(
    .clk_i (clk_i),
    .pc_i (ID_EX.pc_o), // may change to another ALU output when implementing beq
    .pc_o (),
    .Zero_i (ALU.Zero_o),
    .Zero_o (),
    .ALUresult_i (ALU.data_o),
    .ALUresult_o (),
    .RS2data_i (Forwarding_MUX_B.data_o),
    .RS2data_o (),
    .RDaddr_i (ID_EX.RDaddr_o),
    .RDaddr_o (),
    //###Pipline Control Signals###
    //MEM stage control signals
    .MemWrite_i (ID_EX.MemWrite_o),
    .MemWrite_o (),
    .MemRead_i (ID_EX.MemRead_o),
    .MemRead_o (),
    //WB stage control signals
    .MemtoReg_i (ID_EX.MemtoReg_o),
    .MemtoReg_o (),
    .RegWrite_i (ID_EX.RegWrite_o),
    .RegWrite_o ()
);

MEM_WB MEM_WB(
    .clk_i (clk_i),
    .RDaddr_i (EX_MEM.RDaddr_o),
    .RDaddr_o (),
    .ALUresult_i (EX_MEM.ALUresult_o),
    .ALUresult_o (),
    .MEMdata_i (Data_Memory.data_o),
    .MEMdata_o (),
    //###Pipline Control Signals###
    //WB stage control signals
    .MemtoReg_i (EX_MEM.MemtoReg_o),
    .MemtoReg_o (),
    .RegWrite_i (EX_MEM.RegWrite_o),
    .RegWrite_o ()

);

Forwarding_Unit Forwarding_Unit(
    .clk_i  (clk_i),
    .EX_RS1_i (ID_EX.instruction_o [19:15]),
    .EX_RS2_i (ID_EX.instruction_o [24:20]),
    .WB_RD_i (MEM_WB.RDaddr_o),
    .WB_RegWrite_i (MEM_WB.RegWrite_o),
    .MEM_RD_i (EX_MEM.RDaddr_o),
    .MEM_RegWrite_i (EX_MEM.RegWrite_o),
    .ForwardA_o (),
    .ForwardB_o ()
);

Forwarding_MUX Forwarding_MUX_A(
    .port00_i (ID_EX.RS1data_o),
    .port01_i (MUX_MemtoReg.data_o),
    .port10_i (EX_MEM.ALUresult_o),
    .select_i (Forwarding_Unit.ForwardA_o),
    .data_o   ()
);

Forwarding_MUX Forwarding_MUX_B(
    .port00_i (ID_EX.RS2data_o),
    .port01_i (MUX_MemtoReg.data_o),
    .port10_i (EX_MEM.ALUresult_o),
    .select_i (Forwarding_Unit.ForwardB_o),
    .data_o   ()
);

Hazard_Detection Hazard_Detection(
    .ID_EX_MEMRead_i (ID_EX.MemRead_o),
    .ID_EX_RDaddr_i (ID_EX.RDaddr_o),
    .IF_ID_RS1addr_i (IF_ID.instruction_o [19:15]),
    .IF_ID_RS2addr_i (IF_ID.instruction_o [24:20]),
    .PCWrite_o (),
    .IF_ID_Write_o (),
    .Stall_o ()
);

endmodule