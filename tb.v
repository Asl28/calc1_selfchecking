////////////////////////////////////////////////////////////////////////////////////////////
// Code Written By: Sowmith Nethula
// Date: 2018/01/18
// Functional Hardware Verification
// Project #1 Calc_1
////////////////////////////////////////////////////////////////////////////////////////////

module test;

//output ports 
logic unsigned [0:31] out_data1, out_data2, out_data3, out_data4;
logic unsigned [0:1]  out_resp1, out_resp2, out_resp3, out_resp4;
logic unsigned scan_out;
//output ports end


//input ports
logic unsigned a_clk, b_clk, c_clk;
logic unsigned [0:3] error_found;
logic unsigned [0:3] req1_cmd_in, req2_cmd_in, req3_cmd_in, req4_cmd_in;
logic unsigned [0:31] req1_data_in, req2_data_in, req3_data_in, req4_data_in;
logic unsigned [1:7]  reset;
logic unsigned scan_in;
//input ports end

//instantiating the design
calc1_top direct_test (out_data1, out_data2, out_data3, out_data4, 
					   out_resp1, out_resp2, out_resp3, out_resp4, 
					   scan_out, a_clk, b_clk, c_clk, error_found, 
					   req1_cmd_in, req1_data_in, 
					   req2_cmd_in, req2_data_in, 
					   req3_cmd_in, req3_data_in, 
					   req4_cmd_in, req4_data_in, 
					   reset, scan_in); 
					   
//clock
initial
begin
	c_clk = 0;
	error_found = 4'b1111;
end

always #5 c_clk++; // toggle clk after 5 time units

clocking cb @(posedge c_clk);
output req1_cmd_in, req1_data_in, req2_cmd_in, req2_data_in, req3_cmd_in, req3_data_in, req4_cmd_in, req4_data_in, error_found, reset;
input out_data1, out_data2, out_data3, out_data4, out_resp1, out_resp2, out_resp3, out_resp4;
endclocking

default clocking cb;

int unsigned opcode_q1[$];
int unsigned a_q1[$];
int unsigned b_q1[$];
int unsigned result_q1[$];
int unsigned resp_q1[$];
longint unsigned temp_result_q1[$];

int unsigned opcode_q2[$];
int unsigned a_q2[$];
int unsigned b_q2[$];
int unsigned result_q2[$];
int unsigned resp_q2[$];
longint unsigned temp_result_q2[$];

int unsigned opcode_q3[$];
int unsigned a_q3[$];
int unsigned b_q3[$];
int unsigned result_q3[$];
int unsigned resp_q3[$];
longint unsigned temp_result_q3[$];

int unsigned opcode_q4[$];
int unsigned a_q4[$];
int unsigned b_q4[$];
int unsigned result_q4[$];
int unsigned resp_q4[$];
longint unsigned temp_result_q4[$];

int unsigned fail_add = 0;
int unsigned fail_subtract = 0;
int unsigned fail_shiftleft = 0;
int unsigned fail_shiftright = 0;

int unsigned fail_response1 = 0;
int unsigned fail_response2 = 0;
int unsigned fail_response3 = 0;
int unsigned fail_response4 = 0;

int number = 0;

int unsigned a; 
int unsigned b;
int unsigned iter_pin;

task rst(); //reset task
	reset = 7'b1111111;
	$display ("Reset applied on the design at time = %0t", $time);
	##10; // wait for 7 cycles (wait given for 10 cycles)
	reset = 7'b0000000;
	$display ("Reset released on the design at time = %0t", $time);
	$display ("----------------------------------------------------");
endtask

task initalize(); //setting the input pins to zeros
	req1_cmd_in = 0;
	req1_data_in = 0;
	req2_cmd_in = 0;
	req2_data_in = 0;
	req3_cmd_in = 0;
	req3_data_in = 0;
	req4_cmd_in = 0;
	req4_data_in = 0;
endtask

task automatic add(input int unsigned add_pin,oper1,oper2);
	$display ("No#%0d add operation (pin = %0d) between %0d and %0d at time %0t",number,add_pin,oper1,oper2,$time);
	if (add_pin == 1)
		begin
		req1_cmd_in = 1;
		req1_data_in = oper1;
		##1
		req1_cmd_in = 0;
		req1_data_in = oper2;
		
		a_q1.push_front(oper1);
		b_q1.push_front(oper2);
		opcode_q1.push_front(1);
		temp_result_q1.push_front(oper1+oper2);
		end
	else if (add_pin == 2)
		begin
		req2_cmd_in = 1;
		req2_data_in = oper1;
		##1
		req2_cmd_in = 0;
		req2_data_in = oper2;
		
		a_q2.push_front(oper1);
		b_q2.push_front(oper2);
		opcode_q2.push_front(1);
		temp_result_q2.push_front(oper1+oper2);
		end
	else if (add_pin == 3)
		begin
		req3_cmd_in = 1;
		req3_data_in = oper1;
		##1
		req3_cmd_in = 0;
		req3_data_in = oper2;
		
		a_q3.push_front(oper1);
		b_q3.push_front(oper2);
		opcode_q3.push_front(1);
		temp_result_q3.push_front(oper1+oper2);
		end
	else if (add_pin == 4)
		begin
		req4_cmd_in = 1;
		req4_data_in = oper1;
		##1
		req4_cmd_in = 0;
		req4_data_in = oper2;
		
		a_q4.push_front(oper1);
		b_q4.push_front(oper2);
		opcode_q4.push_front(1);
		temp_result_q4.push_front(oper1+oper2);
		end
	else
		begin
		$display ("invalid pin selection");
		end
endtask

task automatic subtract(input int unsigned sub_pin,oper1,oper2);
	$display ("No#%0d subtract operation (pin = %0d) between %0d and %0d at time %0t",number,sub_pin,oper1,oper2,$time);
	if (sub_pin == 1)
		begin
		req1_cmd_in = 2;
		req1_data_in = oper1;
		##1
		req1_cmd_in = 0;
		req1_data_in = oper2;
		
		a_q1.push_front(oper1);
		b_q1.push_front(oper2);
		opcode_q1.push_front(2);
		temp_result_q1.push_front(oper1-oper2);
		end
	else if (sub_pin == 2)
		begin
		req2_cmd_in = 2;
		req2_data_in = oper1;
		##1
		req2_cmd_in = 0;
		req2_data_in = oper2;
		
		a_q2.push_front(oper1);
		b_q2.push_front(oper2);
		opcode_q2.push_front(2);
		temp_result_q2.push_front(oper1-oper2);
		end
	else if (sub_pin == 3)
		begin
		req3_cmd_in = 2;
		req3_data_in = oper1;
		##1
		req3_cmd_in = 0;
		req3_data_in = oper2;
		
		a_q3.push_front(oper1);
		b_q3.push_front(oper2);
		opcode_q3.push_front(2);
		temp_result_q3.push_front(oper1-oper2);
		end
	else if (sub_pin == 4)
		begin
		req4_cmd_in = 2;
		req4_data_in = oper1;
		##1
		req4_cmd_in = 0;
		req4_data_in = oper2;
		
		a_q4.push_front(oper1);
		b_q4.push_front(oper2);
		opcode_q4.push_front(2);
		temp_result_q4.push_front(oper1-oper2);
		end
	else
		begin
		$display ("invalid pin selection");
		end
endtask

task automatic shft_lft(input int unsigned sl_pin,oper1,oper2);
	$display ("No#%0d shift left operation (pin = %0d) on %0b (binary) by %0d (decimal) places at time %0t",number,sl_pin,oper1,oper2,$time);
	if (sl_pin == 1)
		begin
		req1_cmd_in = 5;
		req1_data_in = oper1;
		##1
		req1_cmd_in = 0;
		req1_data_in = oper2;
		
		a_q1.push_front(oper1);
		b_q1.push_front(oper2);
		opcode_q1.push_front(5);
		end
	else if (sl_pin == 2)
		begin
		req2_cmd_in = 5;
		req2_data_in = oper1;
		##1
		req2_cmd_in = 0;
		req2_data_in = oper2;
		
		a_q2.push_front(oper1);
		b_q2.push_front(oper2);
		opcode_q2.push_front(5);
		end
	else if (sl_pin == 3)
		begin
		req3_cmd_in = 5;
		req3_data_in = oper1;
		##1
		req3_cmd_in = 0;
		req3_data_in = oper2;
		
		a_q3.push_front(oper1);
		b_q3.push_front(oper2);
		opcode_q3.push_front(5);
		end
	else if (sl_pin == 4)
		begin
		req4_cmd_in = 5;
		req4_data_in = oper1;
		##1
		req4_cmd_in = 0;
		req4_data_in = oper2;
		
		a_q4.push_front(oper1);
		b_q4.push_front(oper2);
		opcode_q4.push_front(5);
		end
	else
		begin
		$display ("invalid pin selection");
		end
endtask

task automatic shft_rt(input int unsigned sr_pin,oper1,oper2);
	$display ("No#%0d shift right operation (pin = %0d) on %0b (binary) by %0d (decimal) places at time %0t",number,sr_pin,oper1,oper2,$time);
	if (sr_pin == 1)
		begin
		req1_cmd_in = 6;
		req1_data_in = oper1;
		##1
		req1_cmd_in = 0;
		req1_data_in = oper2;
		
		a_q1.push_front(oper1);
		b_q1.push_front(oper2);
		opcode_q1.push_front(6);
		end
	else if (sr_pin == 2)
		begin
		req2_cmd_in = 6;
		req2_data_in = oper1;
		##1
		req2_cmd_in = 0;
		req2_data_in = oper2;
		
		a_q2.push_front(oper1);
		b_q2.push_front(oper2);
		opcode_q2.push_front(6);
		end
	else if (sr_pin == 3)
		begin
		req3_cmd_in = 6;
		req3_data_in = oper1;
		##1
		req3_cmd_in = 0;
		req3_data_in = oper2;
		
		a_q3.push_front(oper1);
		b_q3.push_front(oper2);
		opcode_q3.push_front(6);
		end
	else if (sr_pin == 4)
		begin
		req4_cmd_in = 6;
		req4_data_in = oper1;
		##1
		req4_cmd_in = 0;
		req4_data_in = oper2;
		
		a_q4.push_front(oper1);
		b_q4.push_front(oper2);
		opcode_q4.push_front(6);
		end
	else
		begin
		$display ("invalid pin selection");
		end
endtask

task automatic stimulus(input int unsigned op_code,pin,op1,op2);
number = number+1;
	if (op_code == 0)
		begin
		$display("nop at time %0t", $time); //change
		end
	else if (op_code == 1)
		begin
		add(pin,op1,op2);
		end
	else if (op_code == 2)
		begin
		subtract(pin,op1,op2);
		end
	else if (op_code == 5)
		begin
		shft_lft(pin,op1,op2);
		end
	else if (op_code == 6)
		begin
		shft_rt(pin,op1,op2);
		end
	else 
		begin
		$display ("invalid op_code %0d at time %0t",op_code,$time);
		$display ("operand A = %0d and operand B = %0d", op1,op2);
		
			if (pin == 1)
			begin
			req1_cmd_in = op_code;
			req1_data_in = op1;
			##1
			req1_cmd_in = 0;
			req1_data_in = op2;
			
			a_q1.push_front(op1);
			b_q1.push_front(op2);
			opcode_q1.push_front(op_code);
			end
		else if (pin == 2)
			begin
			req2_cmd_in = op_code;
			req2_data_in = op1;
			##1
			req2_cmd_in = 0;
			req2_data_in = op2;
			
			a_q2.push_front(op1);
			b_q2.push_front(op2);
			opcode_q2.push_front(op_code);
			end
		else if (pin == 3)
			begin
			req3_cmd_in = op_code;
			req3_data_in = op1;
			##1
			req3_cmd_in = 0;
			req3_data_in = op2;
			
			a_q3.push_front(op1);
			b_q3.push_front(op2);
			opcode_q3.push_front(op_code);
			end
		else if (pin == 4)
			begin
			req4_cmd_in = op_code;
			req4_data_in = op1;
			##1
			req4_cmd_in = 0;
			req4_data_in = op2;
			
			a_q4.push_front(op1);
			b_q4.push_front(op2);
			opcode_q4.push_front(op_code);
			end
		else
			begin
			$display ("%0d is invalid pin selection", pin);
			end
		
		end
endtask

task automatic summary();
int log = fail_add+fail_subtract+fail_shiftleft+fail_shiftright;
int noresp = +fail_response1+fail_response2+fail_response3+fail_response4;
	if(log > 0 || noresp > 0)
		begin
		$display("----------------------------------------");
		$display("Test Bench exited with %0d tests FAILED and %0d testcases UN-RESPONSIVE in %0d tests ",log,noresp,number);
		end
	else
		begin
		$display("----------------------------------------");
		$display("Test Bench exited with all tests PASSED");
		end
endtask

always @(out_resp1 or out_resp2 or out_resp3 or out_resp4) //captures out_response and out_data
begin
	if (out_resp1 > 0)
	begin
		#1 
		result_q1.push_front(out_data1);
		resp_q1.push_front(out_resp1);	
	end
	
	if (out_resp2 > 0)
	begin
		#1 
		result_q2.push_front(out_data2);
		resp_q2.push_front(out_resp2);
	end
	
	if (out_resp3 > 0)
	begin
		#1 
		result_q3.push_front(out_data3);
		resp_q3.push_front(out_resp3);
	end
	
	if (out_resp4 > 0)
	begin
		#1 
		result_q4.push_front(out_data4);
		resp_q4.push_front(out_resp4);
	end
	
end

always @(negedge out_resp1) // out_data1 monitor
begin
	if(out_resp1 == 0)
	begin
		if(opcode_q1[0] == 1) //add
		begin
			if (result_q1[0] == a_q1[0]+b_q1[0])
			begin
				$display ("PASS: ADD test between %0d and %0d = %0d on pin 1 at time %0t",a_q1[0],b_q1[0],result_q1[0],$time);
			end
			else
			begin
				fail_add++;
				$display ("FAIL: ADD test between %0d and %0d = %0d [expected value %0d] on (pin 1) at time %0t ----------##FAIL##",a_q1[0],b_q1[0],result_q1[0],{a_q1[0]+b_q1[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q1[0],b_q1[0]);
			end
		end
		
		if(opcode_q1[0] == 2) //subtract
		begin
			if (result_q1[0] == a_q1[0]-b_q1[0])
			begin
				$display ("PASS: SUBTRACT test between %0d and %0d = %0d on pin 1 at time %0t",a_q1[0],b_q1[0],result_q1[0],$time);
			end
			else
			begin
				fail_subtract++;
				$display ("FAIL: SUBTRACT test between %0d and %0d = %0d [expected value %0d] on pin 1 at time %0t ----------##FAIL##",a_q1[0],b_q1[0],result_q1[0],{a_q1[0]-b_q1[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q1[0],b_q1[0]);
			end
		end
		
		if(opcode_q1[0] == 5) //shift left
		begin
			if (result_q1[0] == a_q1[0]<<b_q1[0])
			begin
				$display ("PASS: SHIFT LEFT test on %0b by %0d places = %0b on pin 1 at time %0t",a_q1[0],b_q1[0],result_q1[0],$time);
			end
			else
			begin
				fail_shiftleft++;
				$display ("FAIL: SHIFT LEFT test on %0b by %0d places = %0b [expected value %0b] on pin 1 at time %0t ----------##FAIL##",a_q1[0],b_q1[0],result_q1[0],{a_q1[0]<<b_q1[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q1[0],b_q1[0]);
			end
		end
		
		if(opcode_q1[0] == 6) //shift right
		begin
			if (result_q1[0] == a_q1[0]>>b_q1[0])
			begin
				$display ("PASS: SHIFT RIGHT test on %0b by %0d places = %0b on pin 1 at time %0t",a_q1[0],b_q1[0],result_q1[0],$time);
			end
			else
			begin
				fail_shiftright++;
				$display ("FAIL: SHIFT RIGHT test on %0b by %0d places = %0b [expected value %0b] on pin 1 at time %0t ----------##FAIL##",a_q1[0],b_q1[0],result_q1[0],{a_q1[0]>>b_q1[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q1[0],b_q1[0]);
			end
		end
	end
end

always @(negedge out_resp2) // out_data2 monitor
begin
	if(out_resp2 == 0)
	begin
		if(opcode_q2[0] == 1) //add
		begin
			if (result_q2[0] == a_q2[0]+b_q2[0])
			begin
				$display ("PASS: ADD test between %0d and %0d = %0d on pin 2 at time %0t",a_q2[0],b_q2[0],result_q2[0],$time);
			end
			else
			begin
				fail_add++;
				$display ("FAIL: ADD test between %0d and %0d = %0d [expected value %0d] on (pin 2) at time %0t ----------##FAIL##",a_q2[0],b_q2[0],result_q2[0],{a_q2[0]+b_q2[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q2[0],b_q2[0]);
			end
		end
		
		if(opcode_q2[0] == 2) //subtract
		begin
			if (result_q2[0] == a_q2[0]-b_q2[0])
			begin
				$display ("PASS: SUBTRACT test between %0d and %0d = %0d on pin 2 at time %0t",a_q2[0],b_q2[0],result_q2[0],$time);
			end
			else
			begin
				fail_subtract++;
				$display ("FAIL: SUBTRACT test between %0d and %0d = %0d [expected value %0d] on pin 2 at time %0t ----------##FAIL##",a_q2[0],b_q2[0],result_q2[0],{a_q2[0]-b_q2[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q2[0],b_q2[0]);
			end
		end
		
		if(opcode_q2[0] == 5) //shift left
		begin
			if (result_q2[0] == a_q2[0]<<b_q2[0])
			begin
				$display ("PASS: SHIFT LEFT test on %0b by %0d places = %0b on pin 2 at time %0t",a_q2[0],b_q2[0],result_q2[0],$time);
			end
			else
			begin
				fail_shiftleft++;
				$display ("FAIL: SHIFT LEFT test on %0b by %0d places = %0b [expected value %0b] on pin 2 at time %0t ----------##FAIL##",a_q2[0],b_q2[0],result_q2[0],{a_q2[0]<<b_q2[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q2[0],b_q2[0]);
			end
		end
		
		if(opcode_q2[0] == 6) //shift right
		begin
			if (result_q2[0] == a_q2[0]>>b_q2[0])
			begin
				$display ("PASS: SHIFT RIGHT test on %0b by %0d places = %0b on pin 2 at time %0t",a_q2[0],b_q2[0],result_q2[0],$time);
			end
			else
			begin
				fail_shiftright++;
				$display ("FAIL: SHIFT RIGHT test on %0b by %0d places = %0b [expected value %0b] on pin 2 at time %0t ----------##FAIL##",a_q2[0],b_q2[0],result_q2[0],{a_q2[0]>>b_q2[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q2[0],b_q2[0]);
			end
		end
	end
end

always @(negedge out_resp3) // out_data3 monitor
begin
	if(out_resp3 == 0)
	begin
		if(opcode_q3[0] == 1) //add
		begin
			if (result_q3[0] == a_q3[0]+b_q3[0])
			begin
				$display ("PASS: ADD test between %0d and %0d = %0d on pin 3 at time %0t",a_q3[0],b_q3[0],result_q3[0],$time);
			end
			else
			begin
				fail_add++;
				$display ("FAIL: ADD test between %0d and %0d = %0d [expected value %0d] on (pin 3) at time %0t ----------##FAIL##",a_q3[0],b_q3[0],result_q3[0],{a_q3[0]+b_q3[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q3[0],b_q3[0]);
			end
		end
		
		if(opcode_q3[0] == 2) //subtract
		begin
			if (result_q3[0] == a_q3[0]-b_q3[0])
			begin
				$display ("PASS: SUBTRACT test between %0d and %0d = %0d on pin 3 at time %0t",a_q3[0],b_q3[0],result_q3[0],$time);
			end
			else
			begin
				fail_subtract++;
				$display ("FAIL: SUBTRACT test between %0d and %0d = %0d [expected value %0d] on pin 3 at time %0t ----------##FAIL##",a_q3[0],b_q3[0],result_q3[0],{a_q3[0]-b_q3[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q3[0],b_q3[0]);
			end
		end
		
		if(opcode_q3[0] == 5) //shift left
		begin
			if (result_q3[0] == a_q3[0]<<b_q3[0])
			begin
				$display ("PASS: SHIFT LEFT test on %0b by %0d places = %0b on pin 3 at time %0t",a_q3[0],b_q3[0],result_q3[0],$time);
			end
			else
			begin
				fail_shiftleft++;
				$display ("FAIL: SHIFT LEFT test on %0b by %0d places = %0b [expected value %0b] on pin 3 at time %0t ----------##FAIL##",a_q3[0],b_q3[0],result_q3[0],{a_q3[0]<<b_q3[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q3[0],b_q3[0]);
			end
		end
		
		if(opcode_q3[0] == 6) //shift right
		begin
			if (result_q3[0] == a_q3[0]>>b_q3[0])
			begin
				$display ("PASS: SHIFT RIGHT test on %0b by %0d places = %0b on pin 3 at time %0t",a_q3[0],b_q3[0],result_q3[0],$time);
			end
			else
			begin
				fail_shiftright++;
				$display ("FAIL: SHIFT RIGHT test on %0b by %0d places = %0b [expected value %0b] on pin 3 at time %0t ----------##FAIL##",a_q3[0],b_q3[0],result_q3[0],{a_q3[0]>>b_q3[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q3[0],b_q3[0]);
			end
		end
	end
end

always @(negedge out_resp4) // out_data4 monitor
begin
	if(out_resp4 == 0)
	begin
		if(opcode_q4[0] == 1) //add
		begin
			if (result_q4[0] == a_q4[0]+b_q4[0])
			begin
				$display ("PASS: ADD test between %0d and %0d = %0d on pin 4 at time %0t",a_q4[0],b_q4[0],result_q4[0],$time);
			end
			else
			begin
				fail_add++;
				$display ("FAIL: ADD test between %0d and %0d = %0d [expected value %0d] on (pin 4) at time %0t ----------##FAIL##",a_q4[0],b_q4[0],result_q4[0],{a_q4[0]+b_q4[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q4[0],b_q4[0]);
			end
		end
		
		if(opcode_q4[0] == 2) //subtract
		begin
			if (result_q4[0] == a_q4[0]-b_q4[0])
			begin
				$display ("PASS: SUBTRACT test between %0d and %0d = %0d on pin 4 at time %0t",a_q4[0],b_q4[0],result_q4[0],$time);
			end
			else
			begin
				fail_subtract++;
				$display ("FAIL: SUBTRACT test between %0d and %0d = %0d [expected value %0d] on pin 4 at time %0t ----------##FAIL##",a_q4[0],b_q4[0],result_q4[0],{a_q4[0]-b_q4[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q4[0],b_q4[0]);
			end
		end
		
		if(opcode_q4[0] == 5) //shift left
		begin
			if (result_q4[0] == a_q4[0]<<b_q4[0])
			begin
				$display ("PASS: SHIFT LEFT test on %0b by %0d places = %0b on pin 4 at time %0t",a_q4[0],b_q4[0],result_q4[0],$time);
			end
			else
			begin
				fail_shiftleft++;
				$display ("FAIL: SHIFT LEFT test on %0b by %0d places = %0b [expected value %0b] on pin 4 at time %0t ----------##FAIL##",a_q4[0],b_q4[0],result_q4[0],{a_q4[0]<<b_q4[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q4[0],b_q4[0]);
			end
		end
		
		if(opcode_q4[0] == 6) //shift right
		begin
			if (result_q4[0] == a_q4[0]>>b_q4[0])
			begin
				$display ("PASS: SHIFT RIGHT test on %0b by %0d places = %0b on pin 4 at time %0t",a_q4[0],b_q4[0],result_q4[0],$time);
			end
			else
			begin
				fail_shiftright++;
				$display ("FAIL: SHIFT RIGHT test on %0b by %0d places = %0b [expected value %0b] on pin 4 at time %0t ----------##FAIL##",a_q4[0],b_q4[0],result_q4[0],{a_q4[0]>>b_q4[0]},$time);
				$display ("operand 1 = %b ,operand 2 = %b",a_q4[0],b_q4[0]);
			end
		end
	end
end

// Checking Unresponsive Pins

property pin1response;
@(negedge c_clk)
req1_cmd_in |-> ##[1:7] out_resp1;
endproperty

property pin2response;
@(negedge c_clk)
req2_cmd_in |-> ##[1:7] out_resp2;
endproperty

property pin3response;
@(negedge c_clk)
req3_cmd_in |-> ##[1:7] out_resp3;
endproperty

property pin4response;
@(negedge c_clk)
req4_cmd_in |-> ##[1:7] out_resp4;
endproperty

assert property (pin1response) else begin fail_response1++; $display("UNRESPONSIVE: out_resp1 and out_data1 are un responsive at %0t",$time); end
assert property (pin2response) else begin fail_response2++; $display("UNRESPONSIVE: out_resp2 and out_data1 are un responsive at %0t",$time); end
assert property (pin3response) else begin fail_response3++; $display("UNRESPONSIVE: out_resp3 and out_data3 are un responsive at %0t",$time); end
assert property (pin4response) else begin fail_response4++; $display("UNRESPONSIVE: out_resp4 and out_data4 are un responsive at %0t",$time); end


initial 
begin
	##10
	initalize();
	##2
	rst();
	##2


//addition check 00000000000000000000000000000001 .. 00000000000000000000000000000010 .. 10000000000000000000000000000000 + 0
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
	$display("------------------------------------------------------------");
	$display("single operand left cycle zeros ADD check on pin %0d, time = %0t ns",iter_pin,$time);
	//////////////// a (= 32'b0000......00001 to 32'b100000......000000) + b (= 0)
	a = 1;
	b = 1;
	repeat (32) 
	begin
	a = (a<<1);
	##2 stimulus(1,iter_pin,a,0);
	end
	/////////////////
		
	##2
		
	//////////////// a (= 0) + b (= 32'b0000......00001 to 32'b100000......000000)
	repeat (32) 
	begin
	b = (b<<1);
	##2 stimulus(1,iter_pin,0,b);
	end
	/////////////////
	##5;
end

	
##5

//subtraction test 00000000000000000000000000000001 .. 00000000000000000000000000000010 .. 10000000000000000000000000000000 - 0
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
	$display("------------------------------------------------------------");
	$display("single operand left cycle zeros SUBTRACT check on pin %0d, time = %0t ns",iter_pin,$time);
	//////////////// a (= 32'b0000......00001 to 32'b100000......000000) - b (= 0)
	a = 1;
	b = 1;
	repeat (32) 
	begin
	a = (a<<1);
	##2 stimulus(2,iter_pin,a,0);
	end
	/////////////////
		
	##2
		
	//////////////// a (= 0) - b (= 32'b0000......00001 to 32'b100000......000000)
	repeat (32) 
	begin
	b = (b<<1);
	##2 stimulus(2,iter_pin,0,b);
	end
	/////////////////
##5;
end

##5

//addition check 11111111111111111111111111111110 .. 11111111111111111111111100000000 .. 10000000000000000000000000000000 + 0
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
	$display("------------------------------------------------------------");
	$display("single operand left cycle ones ADD check on pin %0d, time = %0t ns",iter_pin,$time);
	//////////////// a (= 32'b1111......11110 to 32'b100000......000000) + b (= 0)
	a = 32'b11111111_11111111_11111111_11111110;
	b = 32'b11111111_11111111_11111111_11111110;
	repeat (32) 
	begin
	a = (a<<1);
	##2 stimulus(1,iter_pin,a,0);
	end
	/////////////////
		
	##2
		
	//////////////// a (= 0) + b (= 32'b11111......11110 to 32'b100000......000000)
	repeat (32) 
	begin
	b = (b<<1);
	##2 stimulus(1,iter_pin,0,b);
	end
	/////////////////
	##5;
end

	
##5

//subtraction test 11111111111111111111111111111110 .. 11111111111111111111111100000000  .. 10000000000000000000000000000000 - 0
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
	$display("------------------------------------------------------------");
	$display("single operand left cycle ones SUBTRACT check on pin %0d, time = %0t ns",iter_pin,$time);
	//////////////// a (= 32'b111111......11110 to 32'b100000......000000) - b (= 0)
	a = 32'b11111111_11111111_11111111_11111110;
	b = 32'b11111111_11111111_11111111_11111110;
	repeat (32) 
	begin
	a = (a<<1);
	##2 stimulus(2,iter_pin,a,0);
	end
	/////////////////
		
	##2
		
	//////////////// a (= 0) - b (= 32'b1111......11110 to 32'b100000......000000)
	repeat (32) 
	begin
	b = (b<<1);
	##2 stimulus(2,iter_pin,0,b);
	end
	/////////////////
##5;
end

##5

//shift left test 11111111_00000000_11111111_00000000 by 0 to 32 places
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
	$display("------------------------------------------------------------");
	$display("LEFT SHIFT check on pin %0d, time = %0t ns",iter_pin,$time);
	a = 32'b11111111_00000000_11111111_00000000;
	b = 0;
	repeat (33) 
	begin
	##2 stimulus(5,iter_pin,a,b);
	b = b+1;
	end
	/////////////////
##5;
end

##5

//shift right test 11111111_00000000_11111111_00000000 by 0 to 32 places
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
	$display("------------------------------------------------------------");
	$display("RIGHT SHIFT check on pin %0d, time = %0t ns",iter_pin,$time);
	a = 32'b11111111_00000000_11111111_00000000;
	b = 0;
	repeat (33) 
	begin
	##2 stimulus(6,iter_pin,a,b);
	b = b+1;
	end
	/////////////////
##5;
end

##5

$display("------------OverFlow Checks  at time %0t --------------------",$time);
// Over flow Checks in addition b++
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
a = 32'hffffffff;
b = 0;
repeat(10)
	begin
	##5 stimulus(1,iter_pin,a,b);
	b = b+100;
	end
end

##5

// Over flow Checks in addition a++
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
b = 32'hffffffff;
a = 0;
repeat(10)
	begin
	##5 stimulus(1,iter_pin,a,b);
	a = a+100;
	end
end

##5

$display("------------UnderFlow Checks  at time %0t --------------------",$time);
// Under flow Checks in addition b++
for(iter_pin = 1; iter_pin < 5; iter_pin = iter_pin+1)
begin
a = 32'hffffffff;
b = 0;
repeat(10)
	begin
	##5 stimulus(2,iter_pin,b,a);
	b = b-100000;
	end
end

##5

//giving inputs to the 4 pins at once
$display("-----------------ADDITION at once testing at time %0t-----------------",$time);
fork
	stimulus(1,1,2,3);
	stimulus(1,2,2,3);
	stimulus(1,3,2,3);
	stimulus(1,4,2,3);	
join

##5

//giving inputs to the 4 pins at once
$display("-----------------SUBTRACTION at once testing at time %0t-----------------",$time);
fork
	stimulus(2,1,5,3);
	stimulus(2,2,5,3);
	stimulus(2,3,5,3);
	stimulus(2,4,5,3);	
join

##5

//giving inputs to the 4 pins at once
$display("-----------------SHIFT LEFT at once testing at time %0t-----------------",$time);
fork
	stimulus(5,1,5,3);
	stimulus(5,2,5,3);
	stimulus(5,3,5,3);
	stimulus(5,4,5,3);	
join

##5

//giving inputs to the 4 pins at once
$display("-----------------SHIFT RIGHT at once testing at time %0t-----------------",$time);
fork
	stimulus(6,1,5,3);
	stimulus(6,2,5,3);
	stimulus(6,3,5,3);
	stimulus(6,4,5,3);	
join

##5

//giving inputs to the 4 pins at once
$display("-----------------ADD SUB SHL SHR at once testing at time %0t-----------------",$time);
fork
	stimulus(1,1,5,3);
	stimulus(2,2,5,3);
	stimulus(5,3,5,3);
	stimulus(6,4,5,3);	
join

##5

//giving inputs to the 4 pins at once
$display("-----------------SHR SHL SUB ADD at once testing at time %0t-----------------",$time);
fork
	stimulus(6,1,5,3);
	stimulus(5,2,5,3);
	stimulus(2,3,5,3);
	stimulus(1,4,5,3);	
join

##5

//giving inputs to the 4 pins at once
$display("-----------------SHR ADD SHL SUB at once testing at time %0t-----------------",$time);
fork
	stimulus(6,1,5,3);
	stimulus(1,2,5,3);
	stimulus(5,3,5,3);
	stimulus(2,4,5,3);	
join
	##100
	summary();
	$stop;
end


endmodule
