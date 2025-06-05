module tb_alu_4bit;

// Testbench Variables
reg [3:0] A;
reg [3:0] B;
reg [2:0] opcode;
wire [3:0] result;
wire zero_flag;

// Instantiate ALU
alu_4bit uut (.A(A), .B(B), .opcode(opcode), .result(result), .zero_flag(zero_flag));

// To compare with tested results
reg [3:0] expected_result;
reg expected_zero;

initial begin
    // ADD test
    A = 4'd3; B = 4'd2; opcode = 3'b000; expected_result = 4'd5; expected_zero = 0; #10;
    check_result("ADD");

    // SUB test
    opcode = 3'b001; expected_result = 4'd1; expected_zero = 0; #10;
    check_result("SUB");

    // AND test
    opcode = 3'b010; expected_result = 4'd2; expected_zero = 0; #10;
    check_result("AND");

    // OR test
    opcode = 3'b011; expected_result = 4'd3; expected_zero = 0; #10;
    check_result("OR");

    // XOR test
    opcode = 3'b100; expected_result = 4'd1; expected_zero = 0; #10;
    check_result("XOR");

    // EQ test (A=3, B=2; not equal, expect 0)
    opcode = 3'b101; expected_result = 4'd0; expected_zero = 1; #10;
    check_result("EQ");

    // LT test (3 < 2 is false; expect 0)
    opcode = 3'b110; expected_result = 4'd0; expected_zero = 1; #10;
    check_result("LT");

    // NOP test
    opcode = 3'b111; expected_result = 4'd0; expected_zero = 1; #10;
    check_result("NOP");

    $finish;
end

// Check and display test results
task check_result(input [8*4:1] operation);
begin
    if (result == expected_result && zero_flag == expected_zero) begin
        $display("%s Test PASSED | A=%b B=%b Opcode=%b | Result=%b Zero=%b",
                 operation, A, B, opcode, result, zero_flag);
    end else begin
        $display("%s Test FAILED | A=%b B=%b Opcode=%b | Expected Result=%b Zero=%b, Got Result=%b Zero=%b",
                 operation, A, B, opcode, expected_result, expected_zero, result, zero_flag);
    end
end
endtask

endmodule