module IF_ID
(
    clk_i,
    pc_i,
    pc_o,
    instruction_i,
    instruction_o
);

// Ports
input               clk_i;
input   [31:0]      pc_i;
input   [31:0]      instruction_i;
output reg  [31:0]      pc_o;
output reg  [31:0]  instruction_o;


always@(posedge clk_i) begin
    pc_o <= pc_i;
    instruction_o <= instruction_i;
end
endmodule