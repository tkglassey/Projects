// Name: full_adder.v
// Module: FULL_ADDER
//
// Output: S : Sum
//         CO : Carry Out
//
// Input: A : Bit 1
//        B : Bit 2
//        CI : Carry In
//
// Notes: 1-bit full adder implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module FULL_ADDER(S,CO,A,B, CI);
output S,CO;
input A,B, CI;
wire result, CO1, CO2;

	HALF_ADDER half_adder_inst_1(.Y(result), .C(CO1), .A(A), .B(B));
	HALF_ADDER half_adder_inst_2(.Y(S), .C(CO2), .A(result), .B(CI));
	or inst1(CO, CO1, CO2);

endmodule;
