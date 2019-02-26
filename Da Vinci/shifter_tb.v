`include "prj_definition.v"
module SHIFTER_TB;

reg [31:0] A;
reg [31:0] S;
reg LnR;
wire [31:0] Y;
SHIFT32 inst(.Y(Y), .D(A), .S(S), .LnR(LnR));
//SHIFT32_L inst(.Y(Y), .D(A), .S(S));


initial
begin
A=32'b101; S=31'b110; 
LnR = 1;
#5 A=32'b10101; S=32'b0; LnR = 0; 
#5 A=32'b101; S=32'b1; 
#5 A=32'b10101; S=32'b1000; 
LnR = 1'b1;
#5 A=32'b101; S=32'b11; 
#5 A=32'b1; S=32'b1111; 
//LnR = 1'b0;
#5 A=32'b10101; S=32'b101111; 
LnR = 1'b1;
#5 A=32'b0;
end

endmodule
