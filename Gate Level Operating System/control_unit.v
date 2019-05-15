// Name: control_unit.v
// Module: CONTROL_UNIT
// Output: CTRL  : Control signal for data path
//         READ  : Memory read signal
//         WRITE : Memory Write signal
//
// Input:  ZERO : Zero status from ALU
//         CLK  : Clock signal
//         RST  : Reset Signal
//
// Notes: - Control unit synchronize operations of a processor
//          Assign each bit of control signal to control one part of data path
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
`include "prj_definition.v"
module CONTROL_UNIT(CTRL, READ, WRITE, ZERO, INSTRUCTION, CLK, RST); 
// Output signals
output [`CTRL_WIDTH_INDEX_LIMIT:0]  CTRL;
output READ, WRITE;

// input signals
input ZERO, CLK, RST;
input [`DATA_INDEX_LIMIT:0] INSTRUCTION;

reg [`CTRL_WIDTH_INDEX_LIMIT:0] CTRL;

wire [2:0] proc_state;
PROC_SM state_machine(.STATE(proc_state),.CLK(CLK),.RST(RST));
 
reg [5:0]   OPCODE; 
reg [4:0]   RS; 
reg [4:0]   RT; 
reg [4:0]   RD; 
reg [4:0]   SHAMT; 
reg [5:0]   FUNCT; 
reg [15:0]  IMMEDIATE; 
reg [25:0]  ADDRESS; 

assign READ = CTRL[5]; // Memory Read
assign WRITE = CTRL[6]; // Memory Write

initial
begin
	CTRL= 32'b0;
	OPCODE = 6'b0;
	RS = 5'b0;
	RT = 5'b0;
	RD = 5'b0;
	FUNCT = 6'b0;
	SHAMT = 5'b0;
	IMMEDIATE = 16'b0;
	ADDRESS = 26'b0;
end

always @ (proc_state)
begin
    case(proc_state)
	`PROC_FETCH:
	begin
	    CTRL = 32'h20000020;	// MEM read, PC address
	end
	`PROC_DECODE:
	begin
	    CTRL = 32'h00000110;
//	     print_instruction(INSTRUCTION);
/*	    {OPCODE, RS, RT, RD, SHAMT, FUNCT} = INSTRUCTION;
	    {OPCODE, RS, RT, IMMEDIATE } = INSTRUCTION;
	    {OPCODE, ADDRESS}= INSTRUCTION;*/
	end
	`PROC_EXE:
	begin
	   print_instruction(INSTRUCTION);
	  {OPCODE, RS, RT, RD, SHAMT, FUNCT} = INSTRUCTION;
	  {OPCODE, RS, RT, IMMEDIATE } = INSTRUCTION;
	  {OPCODE, ADDRESS}= INSTRUCTION;
	  case(OPCODE) 
	  // R-Type 
	  6'h00 : begin
            case(FUNCT)
                6'h20: //Add
		begin
		    CTRL = 32'h00600100;
		end
                6'h22: //Sub
		begin
		    CTRL = 32'h00a00100;
		end
                6'h2c: //mult
		begin
		    CTRL = 32'h00e00100;
		end
                6'h24: //and
		begin
		    CTRL = 32'h01a00100;
		end
                6'h25: //or
		begin
		    CTRL = 32'h01e00100;
		end
                6'h27: //nor
		begin
		    CTRL = 32'h02200100;
		end
                6'h2a: //slt
		begin
		    CTRL = 32'h02600100;
		end
                6'h02: //srl
		begin
		    CTRL = 32'h01140100; 
		end
                6'h01: //sll
		begin
		    CTRL = 32'h01540100;
		end
                6'h08: //jr
		begin
		    CTRL = 32'h00000100;
		end
                default: 
		begin
		    CTRL = 32'h0;
		end
            endcase
          end 
	  // I-type 
	  6'h08 : //addi
	  begin
	    CTRL = 32'h00480100;
	  end
 	  6'h1d : //multi
	  begin
	    CTRL = 32'h00c80100;
	  end
 	  6'h0c : //andi
	  begin
	    CTRL = 32'h01800100;
	  end
 	  6'h0d : //ori
	  begin
	    CTRL = 32'h01c00100;
	  end
 	  6'h0f: //lui
	  begin
	    CTRL = 32'h00001500;
	  end
 	  6'h0a : //slti
	  begin
	    CTRL = 32'h02480100;
	  end
 	  6'h04 : //beq
	  begin
	    CTRL = 32'h00a00100;
	  end
	  6'h05 : //bne
	  begin
	    CTRL = 32'h00a00100;
	  end
 	  6'h23 : //lw
	  begin
	    CTRL = 32'h00480100;
	  end
 	  6'h2b : //sw
	  begin
	    CTRL = 32'h00480100; 
	  end
	  6'h1b : // push
	  begin 
	    CTRL = 32'h10920180;
	  end
	  6'h1c : // pop
	  begin
	    CTRL = 32'h00520000;
	  end
	  // J-Type 
	  6'h02: //jmp
  	  begin
	    CTRL = 32'h00000000;
	  end
	  6'h03: //jal
	  begin
	    CTRL = 32'h00000900;
	  end
	  6'h1b:  // push
	  begin
	    CTRL = 32'h10920180;
	  end
	  6'h1c:  // pop
	  begin
	    CTRL = 32'h005A0100;
	  end
	  default: CTRL = 32'h00000000;
	  endcase
	end
	`PROC_MEM:
	begin
	  case(OPCODE)
	    6'h1b : // push
	    begin 
	      CTRL = 32'h509201C0;
	    end
	    6'h1c : // pop
	    begin
	      CTRL = 32'h00522020;
	    end
	    6'h23 : // lw
	    begin
	      CTRL = 32'h00481520;
	    end 
 	    6'h2b : // sw 
	    begin
	      CTRL = 32'h00480140;
	    end
	    /*default : 
	    begin
	       MEM_READ = 1'b0; 
	       MEM_WRITE = 1'b0;
	    end*/
	  endcase
	end
	`PROC_WB:
	begin
	 case(OPCODE) 
	  // R-Type 
	  6'h00 : 
	  begin
            case(FUNCT)
		6'h20: //Add
		begin
		    CTRL = 32'h0060930b;
		end
                6'h22: //Sub
		begin
		    CTRL = 32'h00a0930b;
		end
                6'h2c: //mult
		begin
		    CTRL = 32'h00e0930b;
		end
                6'h24: //and
		begin
		    CTRL = 32'h01a0930b;
		end
                6'h25: //or
		begin
		    CTRL = 32'h01e0930b;
		end
                6'h27: //nor
		begin
		    CTRL = 32'h0220930b;
		end
                6'h2a: //slt
		begin
		    CTRL = 32'h0260930b;
		end
                6'h02: //srl
		begin
		    CTRL = 32'h0114930b; 
		end
                6'h01: //sll
		begin
		    CTRL = 32'h0154930b;
		end
                6'h08: // jr
		begin
		    CTRL = 32'h00000109;
		end 
                default: 
		begin
		    CTRL = 32'h0000000b;
		end
	    endcase
          end 
	  // I-type 
	  6'h08 : //addi
	  begin
	    CTRL=  32'h0048970b;
	  end
 	  6'h1d : //multi
	  begin
	    CTRL = 32'h00c8970b;
	  end
 	  6'h0c : //andi
	  begin
	    CTRL = 32'h0180970b;
	  end
 	  6'h0d :  //ori
	  begin
	    CTRL = 32'h01c0970b;
	  end
 	  6'h0f : //lui
	  begin
	    CTRL = 32'h0000d60b;
	  end
 	  6'h0a : //slti
	  begin
	    CTRL = 32'h0248970b;
	  end
 	  6'h04 :  //beq
	  begin
		if(ZERO ===1)
		begin
	  	   CTRL = 32'h00A0150D;
		end
		else
		begin
		    CTRL = 32'h00A0150B;
		end
	  end
	  6'h05 :  //bne
	  begin
		if(ZERO ===0)
		begin
		    CTRL = 32'h00A0150D;
		end
		else
		begin
		    CTRL = 32'h00A0150B;
		end
	  end
 	  6'h23 : //lw
	  begin
	    CTRL = 32'h0048b70b;
	  end
 	  6'h2b ://sw
	  begin
	    CTRL = 32'h0048000b;
	  end
	 // J-Type 
 	  6'h02 :  // jmp
	  begin
	    CTRL = 32'h00000801;
	  end
 	  6'h03 : //jal
	  begin
	    CTRL = 32'h00000A01;
	  end
	  6'h1c : //pop 
	  begin 
	    CTRL = 32'h005BA30b;
	  end
	  6'h1b:  // push
	  begin
	    CTRL = 32'h1093018b;
	  end
	  default:
	  begin
	    CTRL = 32'h0000000b;
	  end
	 endcase
	end
    endcase
end






task print_instruction; 
input [`DATA_INDEX_LIMIT:0] inst; 
reg [5:0]   opcode; 
reg [4:0]   rs; 
reg [4:0]   rt; 
reg [4:0]   rd; 
reg [4:0]   shamt; 
reg [5:0]   funct; 
reg [15:0]  immediate; 
reg [25:0]  address; 
begin // parse the instruction 
// R-type 
{opcode, rs, rt, rd, shamt, funct} = inst; 
// I-type 
{opcode, rs, rt, immediate } = inst; 
// J-type 
{opcode, address} = inst; 
$write("@ %6dns -> [0X%08h] ", $time, inst); 
case(opcode) 
// R-Type 
6'h00 : begin
            case(funct)
                6'h20: $write("add  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h22: $write("sub  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h2c: $write("mul  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h24: $write("and  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h25: $write("or   r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h27: $write("nor  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h2a: $write("slt  r[%02d], r[%02d], r[%02d];", rs, rt, rd);
                6'h01: $write("sll  r[%02d], %2d, r[%02d];", rs, shamt, rd);
                6'h02: $write("srl  r[%02d], 0X%02h, r[%02d];", rs, shamt, rd);
                6'h08: $write("jr   r[%02d];", rs);
                default: $write("");
            endcase
        end 
// I-type 
6'h08 : $write("addi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h1d : $write("muli  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h0c : $write("andi  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h0d : $write("ori   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h0f : $write("lui   r[%02d], 0X%04h;", rt, immediate);
 6'h0a : $write("slti  r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h04 : $write("beq   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h05 : $write("bne   r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h23 : $write("lw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 6'h2b : $write("sw    r[%02d], r[%02d], 0X%04h;", rs, rt, immediate);
 // J-Type 
 6'h02 : $write("jmp   0X%07h;", address); 
 6'h03 : $write("jal   0X%07h;", address); 
 6'h1b : $write("push;"); 
 6'h1c : $write("pop;"); 
 default: $write(""); 
endcase $write("\n"); 
end 
endtask
endmodule;

//------------------------------------------------------------------------------------------
// Module: PROC_SM
// Output: STATE      : State of the processor
//         
// Input:  CLK        : Clock signal
//         RST        : Reset signal
//
// INOUT: MEM_DATA    : Data to be read in from or write to the memory
//
// Notes: - Processor continuously cycle witnin fetch, decode, execute, 
//          memory, write back state. State values are in the prj_definition.v
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 10, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//------------------------------------------------------------------------------------------
module PROC_SM(STATE,CLK,RST);
// list of inputs
input CLK, RST;
// list of outputs
output [2:0] STATE;

reg [2:0] STATE;
reg [2:0] NEXT_STATE;

initial
begin
  STATE = 3'bxxx;
  NEXT_STATE = `PROC_FETCH;  
end

// reset signal handling
always @ (negedge RST)
begin
    STATE = 3'bxxx;
    NEXT_STATE = `PROC_FETCH;
end

always @(posedge CLK)
begin
    STATE = NEXT_STATE;
end

always @(STATE)
begin
    case(STATE)
	`PROC_FETCH: NEXT_STATE = `PROC_DECODE;
	`PROC_DECODE: NEXT_STATE = `PROC_EXE;
	`PROC_EXE: NEXT_STATE = `PROC_MEM;
	`PROC_MEM: NEXT_STATE = `PROC_WB;
	`PROC_WB: NEXT_STATE = `PROC_FETCH;

    endcase
end

endmodule