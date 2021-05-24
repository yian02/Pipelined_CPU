module EX_MEM
(
    clk_i,
    pc_i, // may change to another ALU output when implementing beq
    pc_o,
    Zero_i,
    Zero_o,
    ALUresult_i,
    ALUresult_o,
    RS2data_i,
    RS2data_o,
    RDaddr_i,
    RDaddr_o,
    //###Pipline Control Signals###
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
input               clk_i;
input       [31:0]  pc_i;
output reg  [31:0]  pc_o;
input       [31:0]  ALUresult_i;
output reg  [31:0]  ALUresult_o;
input       [31:0]  RS2data_i;
output reg  [31:0]  RS2data_o;
input       [4:0]   RDaddr_i;
output reg  [4:0]   RDaddr_o;
input               Zero_i;
output reg          Zero_o;
//###Control Signals###
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
    ALUresult_o <= ALUresult_i;
    RS2data_o <= RS2data_i;
    RDaddr_o <= RDaddr_i;
    Zero_o <= Zero_i;
    //###Control Signals###
    //MEM stage control signals
    MemWrite_o <= MemWrite_i;
    MemRead_o <= MemRead_i;
    // WB stage control signals
    MemtoReg_o <= MemtoReg_i;
end
endmodule