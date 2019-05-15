// Name: logic.v
// Module: 
// Input: 
// Output: 
//
// Notes: Common definitions
// 
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
// 64-bit two's complement
module TWOSCOMP64(Y,A);
//output list
output [63:0] Y;
//input list
input [63:0] A;

wire [63:0] inv;
wire dump;
	INV32_1x1 inv_inst_1(inv[31:0], A[31:0]);
	INV32_1x1 inv_inst_2(inv[63:32], A[63:32]);
	RC_ADD_SUB_64 add_inst(Y, dump, inv, 64'b1, 1'b0);

endmodule

// 32-bit two's complement
module TWOSCOMP32(Y,A);
//output list
output [31:0] Y;
//input list
input [31:0] A;

wire [31:0] inv;
wire dump;
	INV32_1x1 inst_1(inv, A);
	RC_ADD_SUB_32 inst_2(Y, dump, inv, 32'b01, 1'b0);

endmodule

module REG32(Q, D, LOAD, CLK, RESET);
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire[31:0] Qbar;

	genvar i;
	generate
	for(i=0;i<32;i=i+1)
	begin : reg_loop
		REG1 reg_inst(Q[i], Qbar[i], D[i], LOAD, CLK, 1'b1, RESET);
	end
	endgenerate

endmodule


// 1 bit register +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module REG1(Q, Qbar, D, L, C, nP, nR);
input D, C, L;
input nP, nR;
output Q,Qbar;

wire load;

	MUX1_2x1 mux_inst_1(load, Q, D, L);
	D_FF flip_flop_inst(Q, Qbar, load, C, nP, nR);

endmodule


// 1 bit flipflop +ve edge, 
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_FF(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire Cbar, res, resBar;

	not not_inst_1(Cbar, C);
	D_LATCH Latch_inst_1(res, resBar, D, Cbar, nP, nR);
	SR_LATCH Latch_inst_2(Q, Qbar, res, resBar, C, nP, nR);

endmodule


// 1 bit D latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module D_LATCH(Q, Qbar, D, C, nP, nR);
input D, C;
input nP, nR;
output Q,Qbar;

wire Dbar, res1, res2;

	not not_inst_1(Dbar, D);
	nand nand_inst_1(res1, D, C);
	nand nand_inst_2(res2, Dbar, C);
	nand nand_inst_3(Q, Qbar, res1, nP);
	nand nand_inst_4(Qbar, Q, res2, nR);

endmodule

// 1 bit SR latch
// Preset on nP=0, nR=1, reset on nP=1, nR=0;
// Undefined nP=0, nR=0
// normal operation nP=1, nR=1
module SR_LATCH(Q,Qbar, S, R, C, nP, nR);
input S, R, C;
input nP, nR;
output Q,Qbar;

wire res1, res2;

	nand nand_inst_1(res1, S, C);
	nand nand_inst_2(res2, R, C);
	nand nand_inst_3(Q, Qbar, res1, nP);
	nand nand_inst_4(Qbar, Q, res2, nR);

endmodule

// 5x32 Line decoder
module DECODER_5x32(D,I);
// output
output [31:0] D;
// input
input [4:0] I;

wire [15:0] temp;
wire notRes;

	DECODER_4x16 decoder_inst(temp[15:0], I[3:0]);
	not not_inst(notRes, I[4]);
	genvar i;
	generate
	for(i=0;i<16;i=i+1)
	begin : decoder_loop
		and and_inst_1(D[i], temp[i], notRes);
		and and_inst_2(D[i+16], temp[i], I[4]);
	end
	endgenerate

endmodule

// 4x16 Line decoder
module DECODER_4x16(D,I);
// output
output [15:0] D;
// input
input [3:0] I;

wire [7:0] temp;
wire notRes;

	DECODER_3x8 decoder_inst(temp[7:0], I[2:0]);
	not not_inst(notRes, I[3]);
	genvar i;
	generate
	for(i=0;i<8;i=i+1)
	begin : decoder_loop
		and and_inst_1(D[i], temp[i], notRes);
		and and_inst_2(D[i+8], temp[i], I[3]);
	end
	endgenerate


endmodule

// 3x8 Line decoder
module DECODER_3x8(D,I);
// output
output [7:0] D;
// input
input [2:0] I;

wire [3:0] temp;
wire notRes;

	DECODER_2x4 decoder_inst(temp[3:0], I[1:0]);
	not not_inst(notRes, I[2]);
	genvar i;
	generate
	for(i=0;i<4;i=i+1)
	begin : decoder_loop
		and and_inst_1(D[i], temp[i], notRes);
		and and_inst_2(D[i+4], temp[i], I[2]);
	end
	endgenerate


endmodule

// 2x4 Line decoder
module DECODER_2x4(D,I);
// output
output [3:0] D;
// input
input [1:0] I;

wire [1:0] notRes;

	not not_inst_1(notRes[0], I[0]);
	not not_inst_2(notRes[1], I[1]);
	and and_inst_1(D[0], notRes[0], notRes[1]);
	and and_inst_2(D[1], I[0], notRes[1]);
	and and_inst_3(D[2], notRes[0], I[1]);
	and and_inst_4(D[3], I[0], I[1]);

endmodule