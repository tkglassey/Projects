// Name: alu.v
// Module: ALU
// Input: OP1[32] - operand 1
//        OP2[32] - operand 2
//        OPRN[6] - operation code
// Output: OUT[32] - output result for the operation
//
// Notes: 32 bit combinatorial ALU
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x7), nor (0x8)
//  - set less than (0x9)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU(OUT, ZERO, OP1, OP2, OPRN);
// input list
input [`DATA_INDEX_LIMIT:0] OP1; // operand 1
input [`DATA_INDEX_LIMIT:0] OP2; // operand 2
input [`ALU_OPRN_INDEX_LIMIT:0] OPRN; // operation code

// output list
output [`DATA_INDEX_LIMIT:0] OUT; // result of the operation.
output ZERO;

wire [`DATA_INDEX_LIMIT:0] res1, res2, res3, res4, res5;
wire [31:0] LO,HI;
wire C0,SnA;
wire addNot;
wire slt;

	and SnA_setup_1( sltWire , OPRN[3], OPRN[0] );
	not SnA_setup_2( notAdd, OPRN[0]);
	or SnA_setup_fin(SnA,notAdd, sltWire);
	
	MULT32 multOP(HI, LO, OP1, OP2);
	SHIFT32 shiftOp(res1, OP1, OP2, OPRN[0]);
	RC_ADD_SUB_32 addOp(res2, CO, OP1, OP2, SnA);
	AND32_2x1 andOP(res3, OP1, OP2);
	OR32_2x1 orOP(res4, OP1, OP2);
	NOR32_2x1 norOP(res5, OP1, OP2);
	
	// 1/2 add/sub, 3 mult, 4/5 Shift R/L, 6/7 and/or, 8 nor, 9 slt
	MUX32_16x1  muxgate(OUT, 32'b0, res2, res2, LO, res1, res1, // 0-5
	 res3, res4, res5, {{31{1'b0}},res2[31]}, 32'b0, 32'b0, // 6-11
	32'b0, 32'b0, 32'b0, 32'b0, {OPRN[3:0]}); // 12-15

	nor zeroCheck(ZERO,OUT[0], OUT[1], OUT[2], OUT[3], OUT[4], 
	OUT[5], OUT[6], OUT[7], OUT[8], OUT[09], OUT[10], OUT[11], 
	OUT[12], OUT[13], OUT[14], OUT[15], OUT[16], OUT[17], OUT[18], 
	OUT[19], OUT[20], OUT[21], OUT[22], OUT[23], OUT[24], OUT[25], 
	OUT[26], OUT[27], OUT[28], OUT[29], OUT[30], OUT[31]);


endmodule
