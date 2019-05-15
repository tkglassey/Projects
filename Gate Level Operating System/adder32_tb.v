`include "prj_definition.v"
module ADDER_32_TB;

reg [31:0] A, B;
reg CI;
wire [31:0] Y;
wire C;
RC_ADD_SUB_32 inst(.Y(Y), .CO(C), .A(A), .B(B), .SnA(CI));

initial
begin
A=32'b0; B=32'b0; CI=0;
#5 A=0; B=0; CI=1;
#5 A=32'd16; B=32'd44; CI=0;
#5 A=32'd18; B=32'd16; CI=1;
#5 A=32'b0; B=32'b0; CI=0;
end

endmodule
