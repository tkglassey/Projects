`include "prj_definition.v"
module MULT_32_TB;

reg [31:0] A, B;
reg CI;
wire [31:0] HI, LO;

MULT32 inst(HI, LO, A, B);

initial
begin
A=0; B=0;
#5 A=24; B=0;
#5 A=32'd16; B=32'd4; 
#5 A=-2; B=4; 
#5 A=-8; B=-3; 
#5 A=0; B=0;
end

endmodule
