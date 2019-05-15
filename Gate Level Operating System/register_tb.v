`include "prj_definition.v"

module REG32_tb;

reg [31:0] inData;
reg LOAD, RST;

wire CLK;
wire [31:0] outData;

// Clock generator instance
CLK_GENERATOR clk_gen_inst(.CLK(CLK));

REG32 reg_inst(outData, inData, LOAD, CLK, RST);

initial
begin
RST=1'b1;
#10    RST=1'b0;
#10    RST=1'b1;

#10     inData=24;
LOAD = 1'b1;
#10     inData=13;
LOAD = 1'b0;
#10     inData=9;
LOAD = 1'b1;
#10    $stop;
end
endmodule
