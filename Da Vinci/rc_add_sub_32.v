// Name: rc_add_sub_32.v
// Module: RC_ADD_SUB_32
//
// Output: Y : Output 32-bit
//         CO : Carry Out
//         
//
// Input: A : 32-bit input
//        B : 32-bit input
//        SnA : if SnA=0 it is add, subtraction otherwise
//
// Notes: 32-bit adder / subtractor implementaiton.
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

module RC_ADD_SUB_64(Y, CO, A, B, SnA);
// output list
output [63:0] Y;
output CO;
// input list
input [63:0] A;
input [63:0] B;
input SnA;

wire [63:0] comp, ci;
	genvar i;
	generate
		for(i=0;i<64;i=i+1)
		begin : ripple
			xor prep(comp[i], B[i], SnA);
			if(i==0)
			begin
				FULL_ADDER full_adder_inst_first(Y[0],ci[0],A[0],comp[0],SnA);
			end
			else
			begin
				FULL_ADDER full_adder_inst(Y[i],ci[i],A[i],comp[i],ci[i-1]);
			end
		end
	endgenerate
	buf fin(CO, ci[63]);

endmodule

module RC_ADD_SUB_32(Y, CO, A, B, SnA);
// output list
output [`DATA_INDEX_LIMIT:0] Y;
output CO;
// input list
input [`DATA_INDEX_LIMIT:0] A;
input [`DATA_INDEX_LIMIT:0] B;
input SnA;

wire [30:0] CI;
wire [`DATA_INDEX_LIMIT:0] BC;

	xor xor_inst_1(BC[0], B[0], SnA);
	xor xor_inst_2(BC[1], B[1], SnA);
	xor xor_inst_3(BC[2], B[2], SnA);
	xor xor_inst_4(BC[3], B[3], SnA);
	xor xor_inst_5(BC[4], B[4], SnA);
	xor xor_inst_6(BC[5], B[5], SnA);
	xor xor_inst_7(BC[6], B[6], SnA);
	xor xor_inst_8(BC[7], B[7], SnA);
	xor xor_inst_9(BC[8], B[8], SnA);
	xor xor_inst_10(BC[9], B[9], SnA);
	xor xor_inst_11(BC[10], B[10], SnA);
	xor xor_inst_12(BC[11], B[11], SnA);
	xor xor_inst_13(BC[12], B[12], SnA);
	xor xor_inst_14(BC[13], B[13], SnA);
	xor xor_inst_15(BC[14], B[14], SnA);
	xor xor_inst_16(BC[15], B[15], SnA);
	xor xor_inst_17(BC[16], B[16], SnA);
	xor xor_inst_18(BC[17], B[17], SnA);
	xor xor_inst_19(BC[18], B[18], SnA);
	xor xor_inst_20(BC[19], B[19], SnA);
	xor xor_inst_21(BC[20], B[20], SnA);
	xor xor_inst_22(BC[21], B[21], SnA);
	xor xor_inst_23(BC[22], B[22], SnA);
	xor xor_inst_24(BC[23], B[23], SnA);
	xor xor_inst_25(BC[24], B[24], SnA);
	xor xor_inst_26(BC[25], B[25], SnA);
	xor xor_inst_27(BC[26], B[26], SnA);
	xor xor_inst_28(BC[27], B[27], SnA);
	xor xor_inst_29(BC[28], B[28], SnA);
	xor xor_inst_30(BC[29], B[29], SnA);
	xor xor_inst_31(BC[30], B[30], SnA);
	xor xor_inst_32(BC[31], B[31], SnA);



	FULL_ADDER full_adder_inst_1(Y[0],CI[0],A[0],BC[0],SnA);
	FULL_ADDER full_adder_inst_2(Y[1],CI[1],A[1],BC[1],CI[0]);
	FULL_ADDER full_adder_inst_3(Y[2],CI[2],A[2],BC[2],CI[1]);
	FULL_ADDER full_adder_inst_4(Y[3],CI[3],A[3],BC[3],CI[2]);
	FULL_ADDER full_adder_inst_5(Y[4],CI[4],A[4],BC[4],CI[3]);
	FULL_ADDER full_adder_inst_6(Y[5],CI[5],A[5],BC[5],CI[4]);
	FULL_ADDER full_adder_inst_7(Y[6],CI[6],A[6],BC[6],CI[5]);
	FULL_ADDER full_adder_inst_8(Y[7],CI[7],A[7],BC[7],CI[6]);
	FULL_ADDER full_adder_inst_9(Y[8],CI[8],A[8],BC[8],CI[7]);
	FULL_ADDER full_adder_inst_10(Y[9],CI[9],A[9],BC[9],CI[8]);
	FULL_ADDER full_adder_inst_11(Y[10],CI[10],A[10],BC[10],CI[9]);
	FULL_ADDER full_adder_inst_12(Y[11],CI[11],A[11],BC[11],CI[10]);
	FULL_ADDER full_adder_inst_13(Y[12],CI[12],A[12],BC[12],CI[11]);
	FULL_ADDER full_adder_inst_14(Y[13],CI[13],A[13],BC[13],CI[12]);
	FULL_ADDER full_adder_inst_15(Y[14],CI[14],A[14],BC[14],CI[13]);
	FULL_ADDER full_adder_inst_16(Y[15],CI[15],A[15],BC[15],CI[14]);
	FULL_ADDER full_adder_inst_17(Y[16],CI[16],A[16],BC[16],CI[15]);
	FULL_ADDER full_adder_inst_18(Y[17],CI[17],A[17],BC[17],CI[16]);
	FULL_ADDER full_adder_inst_19(Y[18],CI[18],A[18],BC[18],CI[17]);
	FULL_ADDER full_adder_inst_20(Y[19],CI[19],A[19],BC[19],CI[18]);
	FULL_ADDER full_adder_inst_21(Y[20],CI[20],A[20],BC[20],CI[19]);
	FULL_ADDER full_adder_inst_22(Y[21],CI[21],A[21],BC[21],CI[20]);
	FULL_ADDER full_adder_inst_23(Y[22],CI[22],A[22],BC[22],CI[21]);
	FULL_ADDER full_adder_inst_24(Y[23],CI[23],A[23],BC[23],CI[22]);
	FULL_ADDER full_adder_inst_25(Y[24],CI[24],A[24],BC[24],CI[23]);
	FULL_ADDER full_adder_inst_26(Y[25],CI[25],A[25],BC[25],CI[24]);
	FULL_ADDER full_adder_inst_27(Y[26],CI[26],A[26],BC[26],CI[25]);
	FULL_ADDER full_adder_inst_28(Y[27],CI[27],A[27],BC[27],CI[26]);
	FULL_ADDER full_adder_inst_29(Y[28],CI[28],A[28],BC[28],CI[27]);
	FULL_ADDER full_adder_inst_30(Y[29],CI[29],A[29],BC[29],CI[28]);
	FULL_ADDER full_adder_inst_31(Y[30],CI[30],A[30],BC[30],CI[29]);
	FULL_ADDER full_adder_inst_32(Y[31],CO,A[31],BC[31],CI[30]);

endmodule

