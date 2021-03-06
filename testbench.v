`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
reg                Reset;
integer            i, outfile, counter;
integer            stall, flush;
parameter          num_cycles = 64;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .start_i(Start),
    .rst_i  (Reset)
);
  
initial begin
    $dumpfile("CPU.vcd");
    $dumpvars;
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end

    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 32'b0;
    end    
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end

    /*
        Pipeline and Control Signal Registers Initialization
    */
    // Control Signals
    CPU.Control.ALUOp_o = 3'b0;
    CPU.Control.ALUSrc_o = 1'b0;
    CPU.Control.RegWrite_o = 1'b0;
    CPU.Control.MemtoReg_o = 1'b0;
    CPU.Control.MemRead_o = 1'b0;
    CPU.Control.MemWrite_o = 1'b0;
    CPU.Sign_Extend.data_o = 32'b0;
    CPU.PC.pc_o = 32'b0;
    //IF_ID
    CPU.IF_ID.pc_o = 32'd0;
    CPU.IF_ID.instruction_o = 32'd0;
    //ID_EX
    CPU.ID_EX.pc_o = 32'b0;
    CPU.ID_EX.RS1data_o = 32'b0;
    CPU.ID_EX.RS2data_o = 32'b0;
    CPU.ID_EX.RDaddr_o = 5'b0;
    CPU.ID_EX.sign_ext_o = 32'd0;
    CPU.ID_EX.ALUsrc_o = 1'b0;
    CPU.ID_EX.ALUOp_o = 2'b0;
    CPU.ID_EX.instruction_o = 32'b0;
    CPU.ID_EX.MemWrite_o = 1'b0;
    CPU.ID_EX.MemRead_o = 1'b0;
    CPU.ID_EX.MemtoReg_o = 1'b0;
    CPU.ID_EX.RegWrite_o = 1'b0;
    //EX_MEM
    CPU.EX_MEM.pc_o = 32'b0;
    CPU.EX_MEM.Zero_o = 1'b0;
    CPU.EX_MEM.ALUresult_o = 32'b0;
    CPU.EX_MEM.RS2data_o = 32'b0;
    CPU.EX_MEM.RDaddr_o = 5'b0;
    CPU.EX_MEM.MemWrite_o = 1'b0;
    CPU.EX_MEM.MemRead_o = 1'b0;
    CPU.EX_MEM.MemtoReg_o = 1'b0;
    CPU.EX_MEM.RegWrite_o = 1'b0;
    //MEM_WB
    CPU.MEM_WB.RDaddr_o = 5'b0;
    CPU.MEM_WB.ALUresult_o = 32'b0;
    CPU.MEM_WB.MEMdata_o = 32'b0;
    CPU.MEM_WB.MemtoReg_o = 1'b0;
    CPU.MEM_WB.RegWrite_o = 1'b0;
    // Hazard Detection Unit
    CPU.Hazard_Detection.IF_ID_Write_o = 1'b0;
    CPU.Hazard_Detection.PCWrite_o = 1'b0;;
    CPU.Hazard_Detection.Stall_o = 1'b0;

    // Load instructions into instruction memory
    // Make sure you change back to "instruction.txt" before submission
    $readmemb("instruction.txt", CPU.Instruction_Memory.memory);

    
    // Open output file
    // Make sure you change back to "output.txt" before submission
    outfile = $fopen("output.txt") | 1;
    
    Clk = 1;
    Reset = 1;
    Start = 0;
    
    #(`CYCLE_TIME/4) 
    Reset = 0;
    Start = 1;
        
    
end
  
always@(posedge Clk) begin
    if(counter == num_cycles)    // stop after num_cycles cycles
        $finish;

    if(counter == 0)
    begin
        // Initialize IF_ID Registers in the initial step (count == 0)
        CPU.IF_ID.pc_o = 32'd0;
        CPU.IF_ID.instruction_o = 32'd0;
    end
    
    // put in your own signal to count stall and flush
    if(CPU.Hazard_Detection.Stall_o == 1 && CPU.Control.Branch_o == 0)stall = stall + 1;
    if(CPU.Flush == 1)flush = flush + 1;  

    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %0d, Stall = %0d, Flush = %0d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "x0 = %d, x8  = %d, x16 = %d, x24 = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "x1 = %d, x9  = %d, x17 = %d, x25 = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "x2 = %d, x10 = %d, x18 = %d, x26 = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "x3 = %d, x11 = %d, x19 = %d, x27 = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "x4 = %d, x12 = %d, x20 = %d, x28 = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "x5 = %d, x13 = %d, x21 = %d, x29 = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "x6 = %d, x14 = %d, x22 = %d, x30 = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "x7 = %d, x15 = %d, x23 = %d, x31 = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %10d", CPU.Data_Memory.memory[0]);
    $fdisplay(outfile, "Data Memory: 0x04 = %10d", CPU.Data_Memory.memory[1]);
    $fdisplay(outfile, "Data Memory: 0x08 = %10d", CPU.Data_Memory.memory[2]);
    $fdisplay(outfile, "Data Memory: 0x0C = %10d", CPU.Data_Memory.memory[3]);
    $fdisplay(outfile, "Data Memory: 0x10 = %10d", CPU.Data_Memory.memory[4]);
    $fdisplay(outfile, "Data Memory: 0x14 = %10d", CPU.Data_Memory.memory[5]);
    $fdisplay(outfile, "Data Memory: 0x18 = %10d", CPU.Data_Memory.memory[6]);
    $fdisplay(outfile, "Data Memory: 0x1C = %10d", CPU.Data_Memory.memory[7]);

    $fdisplay(outfile, "\n");
    
    counter = counter + 1;

      
end

  
endmodule
