/*
  ALU with CARRY-IN[1] ERROR injection:
    • For ADD (000), we force the carry-in to the bit-1 full adder to 1 
      whenever it should have been 0 (and leave it at 0 if the real carry was 1).
    • All other opcodes use the normal A+B or their usual logic.
*/
module alu_4bit_carry1_error (
  input  [3:0] A,
  input  [3:0] B,
  input  [2:0] opcode,
  output reg [3:0] result,
  output reg       zero_flag
);
  // Compute the "wrong" carry into bit-1: 
  // if the real bit-0 carry (A[0]&B[0]) is 0, we overwrite it to 1.
  wire wrong_c1 = ~(A[0] & B[0]) ? 1'b1 : 1'b0;

  // Build a 4-bit "cin vector" whose only nonzero bit is at position 1:
  wire [3:0] C_vec = {3'b000, 1'b0} | (wrong_c1 << 1);

  reg [3:0] tmp;
  always @(*) begin
    // 1) For ADD, inject the bad carry
    if (opcode == 3'b000) begin
      tmp = A + B + C_vec;
    end
    else begin
      // 2) All other ops are normal
      case (opcode)
        3'b001: tmp = A - B;
        3'b010: tmp = A & B;
        3'b011: tmp = A | B;
        3'b100: tmp = A ^ B;
        3'b101: tmp = (A == B) ? 4'b0001 : 4'b0000;
        3'b110: tmp = (A <  B) ? 4'b0001 : 4'b0000;
        3'b111: tmp = 4'b0000;
        default: tmp = 4'b0000;
      endcase
    end

    // 3) Drive outputs
    result    = tmp;
    zero_flag = (tmp == 4'b0000);
  end
endmodule