`timescale 1ns/10ps
// Name: prj_01_tb.v
// Module: prj_01_tb
// Input: 
// Output: 
//
// Notes: Testbench for project 01 testing ALU functionality
// 
// Supports the following functions
//	- Integer add (0x1), sub(0x2), mul(0x3)
//	- Integer shift_rigth (0x4), shift_left (0x5)
//	- Bitwise and (0x6), or (0x8), nor (0x8)
//      - set less than (0x8)
//
// Revision History:
//
// Version	Date		Who		email			note
//------------------------------------------------------------------------------------------
//  1.0     Sep 02, 2014	Kaushik Patra	kpatra@sjsu.edu		Initial creation
//  1.1     Sep 04, 2014	Kaushik Patra	kpatra@sjsu.edu		Fixed test_and_count task
//                                                                      to count number of test and
//                                                                      pass correctly.
//  1.2     Oct 15, 2018	Trevor Glassey	tkglassey@gmail.com	Now includes 0 test.
//------------------------------------------------------------------------------------------
//
`include "prj_definition.v"
module ALU_tb;

integer total_test;
integer pass_test;

reg [`ALU_OPRN_INDEX_LIMIT:0] oprn_reg;
reg [`DATA_INDEX_LIMIT:0] op1_reg;
reg [`DATA_INDEX_LIMIT:0] op2_reg;

wire [`DATA_INDEX_LIMIT:0] r_net;
wire r_zero;

// Instantiation of ALU
ALU ALU_INST_01(.OUT(r_net), .ZERO(r_zero), .OP1(op1_reg), 
                .OP2(op2_reg), .OPRN(oprn_reg));

// Drive the test patterns and test
initial
begin
op1_reg=0;
op2_reg=0;
oprn_reg=0;

total_test = 0;
pass_test = 0;

// test 15 + 3 = 18
#5  op1_reg=15;
    op2_reg=3;
    oprn_reg=`ALU_OPRN_WIDTH'h01;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero));
#5  op1_reg=15;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h02;   
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero));
// Sub ZERO Test
#5  op1_reg=8;
    op2_reg=8;
    oprn_reg=`ALU_OPRN_WIDTH'h02;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero));

#5  op1_reg=3;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h03;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero));

// Mult ZERO Test
#5  op1_reg=0;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h03;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero));

#5  op1_reg=18;
    op2_reg=3;
    oprn_reg=`ALU_OPRN_WIDTH'h04;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 2

#5  op1_reg=24;
    op2_reg=2;
    oprn_reg=`ALU_OPRN_WIDTH'h04;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 6

#5  op1_reg=5;
    op2_reg=3;
    oprn_reg=`ALU_OPRN_WIDTH'h05;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 40

#5  op1_reg=3;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h06;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 1

#5  op1_reg=3;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h07;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 7

#5  op1_reg=3;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h08;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer something astronomically high

#5  op1_reg=-3;
    op2_reg=-7;
    oprn_reg=`ALU_OPRN_WIDTH'h08;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 2?

#5  op1_reg=3;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h09;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 1

#5  op1_reg=17;
    op2_reg=5;
    oprn_reg=`ALU_OPRN_WIDTH'h09;
#5  test_and_count(total_test, pass_test, 
                   test_golden(op1_reg,op2_reg,oprn_reg,r_net,r_zero)); //should answer 0
// 
// TBD: Fill out for other operations
//
#5  $write("\n");
    $write("\tTotal number of tests %d\n", total_test);
    $write("\tTotal number of pass  %d\n", pass_test);
    $write("\n");
    $stop; // stop simulation here
end

//-----------------------------------------------------------------------------
// TASK: test_and_count
// 
// PARAMETERS: 
//     INOUT: total_test ; total test counter
//     INOUT: pass_test ; pass test counter
//     INPUT: test_status ; status of the current test 1 or 0
//
// NOTES: Keeps track of number of test and pass cases.
//
//-----------------------------------------------------------------------------
task test_and_count;
inout total_test;
inout pass_test;
input test_status;

integer total_test;
integer pass_test;
begin
    total_test = total_test + 1;
    if (test_status)
    begin
        pass_test = pass_test + 1;
    end
end
endtask

//-----------------------------------------------------------------------------
// FUNCTION: test_golden
// 
// PARAMETERS: op1, op2, oprn, result, and zero
// RETURN: 1 or 0 if the result matches golden and zero is correct
//
// NOTES: Tests the result against the golden. Golden is generated inside.
//
//-----------------------------------------------------------------------------
function test_golden;
//function test_zero;
input [`DATA_INDEX_LIMIT:0] op1;
input [`DATA_INDEX_LIMIT:0] op2;
input [`ALU_OPRN_INDEX_LIMIT:0] oprn;
input [`DATA_INDEX_LIMIT:0] res;
input [`DATA_INDEX_LIMIT:0] zero;

reg [`DATA_INDEX_LIMIT:0] golden; // expected result
reg [`DATA_INDEX_LIMIT:0] gZero; // expected zero result
begin
    $write("[TEST] %0d ", op1);
    case(oprn)
        `ALU_OPRN_WIDTH'h01 : begin $write("+ "); golden = op1 + op2; end
        `ALU_OPRN_WIDTH'h02 : begin $write("- "); golden = op1 - op2; end
	`ALU_OPRN_WIDTH'h03 : begin $write("* "); golden = op1 * op2; end
	`ALU_OPRN_WIDTH'h04 : begin $write(">> "); golden = op1 >> op2; end
	`ALU_OPRN_WIDTH'h05 : begin $write("<< "); golden = op1 << op2; end
	`ALU_OPRN_WIDTH'h06 : begin $write("& "); golden = op1 & op2; end
	`ALU_OPRN_WIDTH'h07 : begin $write("| "); golden = op1 | op2; end
	`ALU_OPRN_WIDTH'h08 : begin $write("nor "); golden = ~(op1 | op2); end
	`ALU_OPRN_WIDTH'h09 : begin $write("< "); golden = op1 < op2; end
        
        default: begin $write("? "); golden = `DATA_WIDTH'hx; end
    endcase
    gZero = (golden == 'h0)?1'b1 : 1'b0;
    $write("%0d = %0d , got %0d, zero = %0d... ", op2, golden, res, zero);

    test_golden = (res === golden)?1'b1:1'b0; // case equality
    //test_zero = (gZero === zero)?1'b1:1'b0;
    if (test_golden && (gZero===zero))
	$write("[PASSED]");
    else 
        $write("[FAILED]");
    $write("\n");
end
endfunction

endmodule
