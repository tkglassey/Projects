`include "prj_definition.v"
module LOGIC_TB;

reg [63:0] A;
wire [63:0] Y;
TWOSCOMP64 inst(.Y(Y), .A(A));

initial
begin
A=64'b1;
#5 A=64'b0;
end

endmodule
