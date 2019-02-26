// Name: barrel_shifter.v
// Module: SHIFT32_L , SHIFT32_R, SHIFT32
//
// Notes: 32-bit barrel shifter
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"

// 32-bit shift amount shifter
module SHIFT32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [31:0] S;
input LnR;

wire [31:0] result;
wire [26:0] count;

reg [31:0] empty = 0;

	BARREL_SHIFTER32 inst_1(result, D, S[4:0], LnR);
	buf buf_start(count[0], S[5]);
	genvar i;
	generate
		for(i=1; i<27; i=i+1)
		begin : or32x1_gen_loop
			or or_inst(count[i],count[i-1],S[i+5]);
		end
	endgenerate
	MUX32_2x1 inst_2(Y, result, empty, count[26]);

endmodule

// Shift with control L or R shift
module BARREL_SHIFTER32(Y,D,S, LnR);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;
input LnR;
wire[31:0] shiftR, shiftL;

	SHIFT32_R inst_1(shiftR, D, S);
	SHIFT32_L inst_2(shiftL, D, S);
	MUX32_2x1 inst_3(Y, shiftR, shiftL, LnR);

endmodule

// Right shifter
module SHIFT32_R(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0] w1, w2, w4, w8;

	genvar i;
	generate
		for(i=0; i<32; i=i+1)
		begin : r_shift_1_gen_loop
			if(i>30)
			begin
				MUX1_2x1 inst_1(w1[i], D[i], 1'b0, S[0]);
			end
			else
			begin
				MUX1_2x1 inst_1(w1[i], D[i], D[i+1], S[0]);
			end
		end
	endgenerate

	genvar j;
	generate
		for(j=0; j<32; j=j+1)
		begin : r_shift_2_gen_loop
			if(j>29)
			begin
				MUX1_2x1 inst_1(w2[j], w1[j], 1'b0, S[1]);
			end
			else
			begin
				MUX1_2x1 inst_1(w2[j], w1[j], w1[j+2], S[1]);
			end
		end
	endgenerate

	genvar k;
	generate
		for(k=0; k<32; k=k+1)
		begin : r_shift_4_gen_loop
			if(k>27)
			begin
				MUX1_2x1 inst_1(w4[k], w2[k], 1'b0, S[2]);
			end
			else
			begin
				MUX1_2x1 inst_1(w4[k], w2[k], w2[k+4], S[2]);
			end
		end
	endgenerate

	genvar l;
	generate
		for(l=0; l<32; l=l+1)
		begin : r_shift_8_gen_loop
			if(l>23)
			begin
				MUX1_2x1 inst_1(w8[l], w4[l], 1'b0, S[3]);
			end
			else
			begin
				MUX1_2x1 inst_1(w8[l], w4[l], w4[l+8], S[3]);
			end
		end
	endgenerate

	genvar m;
	generate
		for(m=0; m<32; m=m+1)
		begin : l_shift_16_gen_loop
			if(m>15)
			begin
				MUX1_2x1 inst_1(Y[m], w8[m], 1'b0, S[4]);
			end
			else
			begin
				MUX1_2x1 inst_1(Y[m], w8[m], w8[m+16], S[4]);
			end
		end
	endgenerate

endmodule

// Left shifter
module SHIFT32_L(Y,D,S);
// output list
output [31:0] Y;
// input list
input [31:0] D;
input [4:0] S;

wire [31:0] w1, w2, w4, w8;
	genvar i;
	generate
		for(i=0; i<32; i=i+1)
		begin : l_shift_1_gen_loop
			if(i<1)
			begin
				MUX1_2x1 inst1(.Y(w1[i]), .I0(D[i]), .I1(1'b0), .S(S[0]));
			end
			else
			begin
				MUX1_2x1 inst2(.Y(w1[i]), .I0(D[i]), .I1(D[i-1]), .S(S[0]));
			end
		end
	endgenerate

	genvar j;
	generate
		for(j=0; j<32; j=j+1)
		begin : l_shift_2_gen_loop
			if(j<2)
			begin
				MUX1_2x1 inst1(.Y(w2[j]), .I0(w1[j]), .I1(1'b0), .S(S[1]));
			end
			else
			begin
				MUX1_2x1 inst2(.Y(w2[j]), .I0(w1[j]), .I1(w1[j-2]), .S(S[1]));
			end
		end
	endgenerate

	genvar k;
	generate
		for(k=0; k<32; k=k+1)
		begin : l_shift_4_gen_loop
			if(k<4)
			begin
				MUX1_2x1 inst1(.Y(w4[k]), .I0(w2[k]), .I1(1'b0), .S(S[2]));
			end
			else
			begin
				MUX1_2x1 inst2(.Y(w4[k]), .I0(w2[k]), .I1(w2[k-4]), .S(S[2]));
			end
		end
	endgenerate

	genvar l;
	generate
		for(l=0; l<32; l=l+1) 
		begin : l_shift_8_gen_loop
			if(l<8)
			begin
				MUX1_2x1 inst1(.Y(w8[l]), .I0(w4[l]), .I1(1'b0), .S(S[3]));
			end
			else
			begin
				MUX1_2x1 inst2(.Y(w8[l]), .I0(w4[l]), .I1(w4[l-8]), .S(S[3]));
			end
		end
	endgenerate

	genvar m;
	generate
		for(m=0; m<32; m=m+1)
		begin : l_shift_16_gen_loop
			if(m<16)
			begin
				MUX1_2x1 inst1(.Y(Y[m]), .I0(w8[m]), .I1(1'b0), .S(S[4]));
			end
			else
			begin
				MUX1_2x1 inst2(.Y(Y[m]), .I0(w8[m]), .I1(w8[m-16]), .S(S[4]));
			end
		end
	endgenerate

endmodule

