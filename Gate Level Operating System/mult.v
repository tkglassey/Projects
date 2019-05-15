// Name: mult.v
// Module: MULT32 , MULT32_U
//
// Output: HI: 32 higher bits
//         LO: 32 lower bits
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//
// Notes: 32-bit multiplication
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module MULT32(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire [63:0] result, flipped;
wire [31:0] connection [3:0];
wire PnN;

	xor sign(PnN, A[31], B[31]);

	TWOSCOMP32 comp_inst_1(connection[0], A);
	MUX32_2x1 mux_inst_1(connection[1], A, connection[0], A[31]);

	TWOSCOMP32 comp_inst_2(connection[2], B);
	MUX32_2x1 mux_inst_2(connection[3], B, connection[2], B[31]);

	MULT32_U mult_inst(result[63:32], result[31:0], connection[1], connection[3]);
	TWOSCOMP64 comp_inst_3(flipped, result);
	MUX32_2x1 mux_inst_3(LO, result[31:0], flipped[31:0], PnN);
	MUX32_2x1 mux_inst_4(HI, result[63:32], flipped[63:32], PnN);
	

endmodule

module MULT32_U(HI, LO, A, B);
// output list
output [31:0] HI;
output [31:0] LO;
// input list
input [31:0] A;
input [31:0] B;

wire [31:0] result [31:0];
wire ands [31:0];
wire [31:0] co;

	AND32_2x1 and32_pre(result[0], A, {32{B[0]}});
	buf inst1(co[0], 1'b0);
	buf inst2(LO[0], result[0][0]);
	genvar i;
	generate
	for(i=1; i<31; i=i+1)
	begin
		wire[31:0] mtplwire;
		AND32_2x1 and32_inst(mtplwire, A, {32{B[i]}});
		RC_ADD_SUB_32 add32_inst(result[i], co[i], mtplwire, {co[i-1], {result[i-1][31:1]}}, 1'b0);
		buf res(LO[i], result[i][0]); 
	end
	endgenerate
	wire[31:0] mtplwire;
	AND32_2x1 and32_inst(mtplwire, A, {32{B[31]}});
	RC_ADD_SUB_32 add32_inst({HI[30:0],LO[31]}, HI[31], mtplwire, {co[30], {result[30][31:1]}}, 1'b0);
	//buf res(LO[31], result[31][0]); 
	// assign HI = {co[31],{result[31][31:1]}};
endmodule
