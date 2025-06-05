/*
  ALU with Module-Substitution Error (MSE)
  • opcode==010 (AND)  → uses OR
  • opcode==011 (OR)   → uses AND
  • opcode==100 (XOR)  → uses AND
*/

module alu_4bit_mse (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] opcode,
    output reg [3:0] result,
    output reg       zero_flag
);

  always @(*) begin
    case (opcode)
      3'b000: result = A + B;                       // ADD
      3'b001: result = A - B;                       // SUB

      // MSEs:
      3'b010: result = A | B;                       // AND→OR
      3'b011: result = A & B;                       //  OR→AND
      3'b100: result = A & B;                       // XOR→AND

      // The rest are unchanged:
      3'b101: result = (A == B) ? 4'b0001 : 4'b0000; // EQ
      3'b110: result = (A <  B) ? 4'b0001 : 4'b0000; // LT
      3'b111: result = 4'b0000;                     // NOP
      default: result = 4'b0000;                    // safety net
    endcase

    // zero flag logic remains identical
    zero_flag = (result == 4'b0000);
  end

endmodule