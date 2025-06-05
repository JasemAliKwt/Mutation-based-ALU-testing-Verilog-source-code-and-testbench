/*
  ALU with SIGNED-BIT ERROR injection:
    • For ADD (000) and SUB (001), we invert the most-significant bit of the 
      "true" result to model a broken sign-bit latch.
*/
module alu_4bit_sgnbit_error (
  input  [3:0] A,
  input  [3:0] B,
  input  [2:0] opcode,
  output reg [3:0] result,
  output reg       zero_flag
);
  reg [3:0] tmp;

  always @(*) begin
    // 1) Compute the golden result into tmp
    case (opcode)
      3'b000: tmp = A + B;                          // ADD
      3'b001: tmp = A - B;                          // SUB
      3'b010: tmp = A & B;                          // AND
      3'b011: tmp = A | B;                          // OR
      3'b100: tmp = A ^ B;                          // XOR
      3'b101: tmp = (A == B) ? 4'b0001 : 4'b0000;    // EQ
      3'b110: tmp = (A <  B) ? 4'b0001 : 4'b0000;    // LT
      3'b111: tmp = 4'b0000;                        // NOP
      default: tmp = 4'b0000;
    endcase

    // 2) Inject the signed-bit fault only for ADD/SUB
    if (opcode == 3'b000 || opcode == 3'b001)
      result = { ~tmp[3], tmp[2:0] };  // invert MSB
    else
      result = tmp;

    // 3) Zero-flag is unchanged
    zero_flag = (result == 4'b0000);
  end
endmodule