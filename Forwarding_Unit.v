module Forwarding_Unit(
    clk_i,
    EX_RS1_i,
    EX_RS2_i,
    WB_RD_i,
    WB_RegWrite_i,
    MEM_RD_i,
    MEM_RegWrite_i,
    ForwardA_o,
    ForwardB_o
);

input clk_i;
input EX_RS1_i;
input EX_RS2_i;
input WB_RD_i;
input WB_RegWrite_i;
input MEM_RD_i;
input MEM_RegWrite_i;

output reg ForwardA_o;
output reg ForwardB_o;

always@(posedge clk_i)
begin
    // Forward A
    if( (MEM_RD_i != 5'b0) && (MEM_RD_i == EX_RS1_i) )
    begin
        ForwardA_o <= 10;
    end
    else if(WB_RegWrite_i && (! ( MEM_RegWrite_i && (MEM_RD_i != 0) && (MEM_RD_i == EX_RS1_i) )  ) && (WB_RD_i == EX_RS1_i) ) 
    begin
        ForwardA_o <= 01;
    end
    else begin
        ForwardA_o <= 2'b00;
    end

    // Forward B
    if( (MEM_RD_i != 5'b0) && (MEM_RD_i == EX_RS2_i) )
    begin
        ForwardB_o <= 10;
    end
    else if(WB_RegWrite_i && (! ( MEM_RegWrite_i && (MEM_RD_i != 0) && (MEM_RD_i == EX_RS2_i) )  ) && (WB_RD_i == EX_RS2_i) )
    begin
        ForwardB_o <= 01;
    end
    else begin
        ForwardB_o <= 2'b00;
    end
end

endmodule