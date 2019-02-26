// Name: register_file.v
// Module: REGISTER_FILE_32x32
// Input:  DATA_W : Data to be written at address ADDR_W
//         ADDR_W : Address of the memory location to be written
//         ADDR_R1 : Address of the memory location to be read for DATA_R1
//         ADDR_R2 : Address of the memory location to be read for DATA_R2
//         READ    : Read signal
//         WRITE   : Write signal
//         CLK     : Clock signal
//         RST     : Reset signal
// Output: DATA_R1 : Data at ADDR_R1 address
//         DATA_R2 : Data at ADDR_R1 address
//
// Notes: - 32 bit word accessible dual read register file having 32 regsisters.
//        - Reset is done at -ve edge of the RST signal
//        - Rest of the operation is done at the +ve edge of the CLK signal
//        - Read operation is done if READ=1 and WRITE=0
//        - Write operation is done if WRITE=1 and READ=0
//        - X is the value at DATA_R* if both READ and WRITE are 0 or 1
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"

// This is going to be +ve edge clock triggered register file.
// Reset on RST=0
module REGISTER_FILE_32x32(DATA_R1, DATA_R2, ADDR_R1, ADDR_R2, 
                            DATA_W, ADDR_W, READ, WRITE, CLK, RST);

// input list
input READ, WRITE, CLK, RST;
input [`DATA_INDEX_LIMIT:0] DATA_W;
input [`REG_ADDR_INDEX_LIMIT:0] ADDR_R1, ADDR_R2, ADDR_W;

// output list
output [`DATA_INDEX_LIMIT:0] DATA_R1;
output [`DATA_INDEX_LIMIT:0] DATA_R2;

wire [31:0] decoderRes, andRes, R1_temp, R2_temp;
wire [31:0] registerData [31:0];

	DECODER_5x32 decoder_inst(decoderRes, ADDR_W);
	genvar i;
	generate
	for(i=0;i<32;i=i+1)
	begin: andLoop
		and and_inst(andRes[i], decoderRes[i], WRITE);
	end
	endgenerate
	
	genvar j;
	generate
	for(j=0;j<32;j=j+1)
	begin: registerLoop
		REG32 reg_inst(registerData[j], DATA_W, andRes[j], CLK, RST);
	end
	endgenerate

	MUX32_32x1 R1_mux_1(R1_temp, registerData[0], registerData[1], registerData[2],
			registerData[3], registerData[4], registerData[5], registerData[6],
			registerData[7], registerData[8], registerData[9], registerData[10],
			registerData[11], registerData[12], registerData[13], registerData[14],
			registerData[15], registerData[16], registerData[17], registerData[18],
			registerData[19], registerData[20], registerData[21], registerData[22],
			registerData[23], registerData[24], registerData[25], registerData[26],
			registerData[27], registerData[28], registerData[29], registerData[30],
			registerData[31], ADDR_R1); 

	MUX32_32x1 R2_mux_1(R2_temp, registerData[0], registerData[1], registerData[2],
			registerData[3], registerData[4], registerData[5], registerData[6],
			registerData[7], registerData[8], registerData[9], registerData[10],
			registerData[11], registerData[12], registerData[13], registerData[14],
			registerData[15], registerData[16], registerData[17], registerData[18],
			registerData[19], registerData[20], registerData[21], registerData[22],
			registerData[23], registerData[24], registerData[25], registerData[26],
			registerData[27], registerData[28], registerData[29], registerData[30],
			registerData[31], ADDR_R2); 
	
	MUX32_2x1 R1_mux_2(DATA_R1, 32'bzzzzzzzz, R1_temp, READ);
	MUX32_2x1 R2_mux_2(DATA_R2, 32'bzzzzzzzz, R2_temp, READ);


endmodule
