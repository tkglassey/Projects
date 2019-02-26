// Name: data_path.v
// Module: DATA_PATH
// Output:  DATA : Data to be written at address ADDR
//          ADDR : Address of the memory location to be accessed
//
// Input:   DATA : Data read out in the read operation
//          CLK  : Clock signal
//          RST  : Reset signal
//
// Notes: - 32 bit processor implementing cs147sec05 instruction set
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module DATA_PATH(DATA_OUT, ADDR, ZERO, INSTRUCTION, DATA_IN, CTRL, CLK, RST);

// output list
output [`ADDRESS_INDEX_LIMIT:0] ADDR;
output ZERO;
output [`DATA_INDEX_LIMIT:0] DATA_OUT, INSTRUCTION;

// input list
input [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
input CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_IN;

wire [31:0] pc, sp, pc_imm, pc_add_1;
wire [31:0] r1_data, r2_data;
wire [31:0] op1_sel_1_out, op2_sel_1_out, op2_sel_2_out, op2_sel_3_out, op2_sel_4_out;
wire [31:0] wa_sel_1_out, wa_sel_2_out, wa_sel_3_out;
wire [31:0] wd_sel_1_out, wd_sel_2_out, wd_sel_3_out;
wire [31:0] ma_sel_1_out;  	//ma_sel_2 goes directly to address
				//md_sel_1 goes directly to data out
wire [31:0] r1_sel_1_out;
wire [31:0] pc_sel_1_out, pc_sel_2_out, pc_sel_3_out;
wire [31:0] alu_out;

	// CTRL SIGNALS BASED ON HOMEWORK 2 (Note, ALU OPRN was longer forcing additional adjustments
/*	CTRL[0] PC_LOAD
	CTRL[1] pc_sel_1
	CTRL[2] pc_sel_2
	CTRL[3] pc_sel_3
	CTRL[4] ir_load
	CTRL[5] mem_r
	CTRL[6] mem_w
	CTRL[7] r1_sel_1
	CTRL[8] reg_r
	CTRL[9] reg_w
	CTRL[10] wa_sel_1
	CTRL[11] wa_sel_2
	CTRL[12] wa_sel_3
	CTRL[13] wd_sel_1
	CTRL[14] wd_sel_2
	CTRL[15] wd_sel_3
	CTRL[16] sp_load
	CTRL[17] op1_sel_1
	CTRL[18] op2_sel_1
	CTRL[19] op2_sel_2
	CTRL[20] op2_sel_3
	CTRL[21] op2_sel_4
	CTRL[22-27] Alu_oprn
	CTRL[28] ma_sel_1
	CTRL[29] ma_sel_2
	CTRL[30] md_sel_1

		Reference Instruction parsing
	reg [5:0]   OPCODE; 
	reg [4:0]   RS; 
	reg [4:0]   RT; 
	reg [4:0]   RD; 
	reg [4:0]   SHAMT; 
	reg [5:0]   FUNCT; 
	reg [15:0]  IMMEDIATE; 
	reg [25:0]  ADDRESS; 
	    // R-type 
	    {OPCODE[0:5], RS[6:10], RT[11:15], RD[16:20], SHAMT[21:25, FUNCT[26:31} = INST_REG; 
	    // I-type 
	    {OPCODE[0:5], RS[6:10], RT[11:15], IMMEDIATE[16:31] } = INST_REG; 
	    // J-type 
	    {OPCODE[0:5], ADDRESS[6:31]} = INST_REG; 
*/

	REG32_PC pc_inst(pc, pc_sel_3_out, CTRL[0], CLK, RST);

	MUX32_2x1 pc_sel_1(pc_sel_1_out, r1_data, pc_add_1, CTRL[1]);
	MUX32_2x1 pc_sel_2(pc_sel_2_out, pc_sel_1_out, pc_imm, CTRL[2]);
	MUX32_2x1 pc_sel_3(pc_sel_3_out, {{6'b0}, INSTRUCTION[25:0]}, pc_sel_2_out, CTRL[3]);

	REG32 instruction_register_inst(INSTRUCTION, DATA_IN, CTRL[4], CLK, RST);

	// 5 na
	// 6 na

	MUX32_2x1 r1_sel_1(r1_sel_1_out, {{27{1'b0}}, INSTRUCTION[25:21]}, 32'b0, CTRL[7]);

	REGISTER_FILE_32x32 reg_file(r1_data, r2_data, r1_sel_1_out[4:0], 
					INSTRUCTION[20:16], wd_sel_3_out, wa_sel_3_out[4:0], 
					CTRL[8], CTRL[9], CLK, RST);

	MUX32_2x1 wa_sel_1(wa_sel_1_out, {{27{1'b0}}, INSTRUCTION[15:11]}, {{27{1'b0}}, INSTRUCTION[20:16]}, CTRL[10]);
	MUX32_2x1 wa_sel_2(wa_sel_2_out, 32'b0, 32'b11111, CTRL[11]);
	MUX32_2x1 wa_sel_3(wa_sel_3_out, wa_sel_2_out, wa_sel_1_out, CTRL[12]);

	MUX32_2x1 wd_sel_1(wd_sel_1_out, alu_out, DATA_IN, CTRL[13]);
	MUX32_2x1 wd_sel_2(wd_sel_2_out, wd_sel_1_out, {INSTRUCTION[15:0], {16'b0}}, CTRL[14]);
	MUX32_2x1 wd_sel_3(wd_sel_3_out, pc_add_1, wd_sel_2_out, CTRL[15]);

	REG32_SP sp_inst(sp, alu_out, CTRL[16], CLK, RST);

	MUX32_2x1 op1_sel_1(op1_sel_1_out, r1_data, sp, CTRL[17]);
	MUX32_2x1 op2_sel_1(op2_sel_1_out, 32'b1, {{27'b0}, INSTRUCTION[10:6]}, CTRL[18]);
	MUX32_2x1 op2_sel_2(op2_sel_2_out, {{16'b0}, INSTRUCTION[15:0]}, {{16{INSTRUCTION[15]}}, INSTRUCTION[15:0]}, CTRL[19]);
	MUX32_2x1 op2_sel_3(op2_sel_3_out, op2_sel_2_out, op2_sel_1_out, CTRL[20]);
	MUX32_2x1 op2_sel_4(op2_sel_4_out, op2_sel_3_out, r2_data, CTRL[21]);

	ALU alu(alu_out, ZERO, op1_sel_1_out, op2_sel_4_out, CTRL[27:22]);

	MUX32_2x1 ma_sel_1(ma_sel_1_out, alu_out, sp, CTRL[28]);
	MUX32_2x1 ma_sel_2(ADDR, ma_sel_1_out, pc, CTRL[29]);

	MUX32_2x1 md_sel_1(DATA_OUT, r2_data, r1_data, CTRL[30]);

	RC_ADD_SUB_32 pc_1_adder(pc_add_1, decoy1, pc, 32'b1, 1'b0);
	RC_ADD_SUB_32 pc_imm_adder(pc_imm, decoy2, pc_add_1, {{16{INSTRUCTION[15]}}, INSTRUCTION[15:0]}, 1'b0);

endmodule

module REG32_PC(Q, D, LOAD, CLK, RESET);
parameter startingVal = `INST_START_ADDR;
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire [31:0] Qbar;

	genvar i;
	generate 
	for(i=0; i<32; i=i+1)
	begin : PC_reg32_loop
		if (startingVal[i] == 0)
			REG1 reg_inst(Q[i], Qbar[i], D[i], LOAD, CLK, 1'b1, RESET);  
		else
			REG1 reg_inst(Q[i], Qbar[i], D[i], LOAD, CLK, RESET, 1'b1);
	end 
	endgenerate

endmodule



module REG32_SP(Q, D, LOAD, CLK, RESET);
parameter startingVal = `INIT_STACK_POINTER;
output [31:0] Q;

input CLK, LOAD;
input [31:0] D;
input RESET;

wire [31:0] Qbar;

	genvar i;
	generate 
	for(i=0; i<32; i=i+1)
	begin : SP_reg32_loop
		if (startingVal[i] == 0)
			REG1 reg_inst(Q[i], Qbar[i], D[i], LOAD, CLK, 1'b1, RESET); 
		else
			REG1 reg_inst(Q[i], Qbar[i], D[i], LOAD, CLK, RESET, 1'b1);
	end 
	endgenerate

endmodule
