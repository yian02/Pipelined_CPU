module MEM_WB
(
    clk_i,
    RDaddr_i,
    RDaddr_o,
    ALUresult_i,
    ALUresult_o,
    MEMdata_i,
    MEMdata_o,
    //###Pipline Control Signals###
    //WB stage control signals
    MemtoReg_i,
    MemtoReg_o
);

// Ports
input               clk_i;
input   [4:0]      RDaddr_i;
output reg  [4:0]  RDaddr_o;
input   [31:0]      ALUresult_i;
output reg  [31:0]  ALUresult_o;
input   [31:0]      MEMdata_i;
output reg  [31:0]  MEMdata_o;
//###Control Signals###
//WB stage control signal
input       MemtoReg_i;
output reg  MemtoReg_o;

always@(posedge clk_i) begin
    RDaddr_o <= RDaddr_i;
    ALUresult_o <= ALUresult_i;
    MEMdata_o <= MEMdata_i;
    //###Control Signals###
    // WB stage control signals
    MemtoReg_o <= MemtoReg_i;
end
endmodule