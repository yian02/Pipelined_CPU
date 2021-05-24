module ID_EX
(
    // Pipeline Registers
    clk_i,
    pc_i,       // 32 bits
    pc_o,       // 32 bits
    RS1data_i,  // 32 bits
    RS1data_o,  // 32 bits
    RS2data_i,  // 32 bits
    RS2data_o,  // 32 bits
    RDaddr_i,   // 5 bits
    RDaddr_o,   // 5 bits
    sign_ext_i, // 32 bits
    sign_ext_o,  // 32 bits
    //###Pipline Control Signals###
    //EXE stage control signals
    ALUsrc_i,
    ALUsrc_o,
    ALUOp_i,
    ALUOp_o,
    //MEM stage control signals
    MemWrite_i,
    MemWrite_o,
    MemRead_i,
    MemRead_o,
    //WB stage control signals
    MemtoReg_i,
    MemtoReg_o
);

// Ports
input                   clk_i;
input       [31:0]      pc_i;
output reg  [31:0]      pc_o;
input       [31:0]      RS1data_i;  // 32 bits
output reg  [31:0]      RS1data_o;  // 32 bits
input       [31:0]      RS2data_i;  // 32 bits
output reg  [31:0]      RS2data_o;  // 32 bits
input       [4:0]       RDaddr_i;   // 5 bits
output reg  [4:0]       RDaddr_o;   // 5 bits
input       [31:0]      sign_ext_i;
output reg  [31:0]      sign_ext_o;
//###Control Signals###
//EX stage control signal
input       ALUsrc_i;
output reg  ALUsrc_o;
input       ALUOp_i;
output reg  ALUOp_o;
//MEM stage control signal
input       MemWrite_i;
output reg  MemWrite_o;
input       MemRead_i;
output reg  MemRead_o;
//WB stage control signal
input       MemtoReg_i;
output reg  MemtoReg_o;


always@(posedge clk_i) begin
    pc_o <= pc_i;
    RS1data_o <= RS1data_i;
    RS2data_o <= RS2data_i;
    RDaddr_o <= RDaddr_i;
    sign_ext_o <= sign_ext_i;
    //###Control Signals###
    //EX stage control signals
    ALUsrc_o <= ALUsrc_i;
    ALUOp_o <= ALUOp_i;
    //MEM stage control signals
    MemWrite_o <= MemWrite_i;
    MemRead_o <= MemRead_i;
    // WB stage control signals
    MemtoReg_o <= MemtoReg_i;
end

endmodule