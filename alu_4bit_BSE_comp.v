/*
  ALU with BSE on the comparator (EQ) stage:
    • opcode==3'b101 (EQ) uses (B==B) instead of (A==B).
*/

module alu_4bit_BSE_comp (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] opcode,
    output reg [3:0] result,
    output reg       zero_flag
);

  always @(*) begin
    case (opcode)
      3'b000: result = A + B;                         // ADD
      3'b001: result = A - B;                         // SUB
      3'b010: result = A & B;                         // AND
      3'b011: result = A | B;                         // OR
      3'b100: result = A ^ B;                         // XOR

      // Bus-Source Error: comparator now ignores A, does (B==B)
      3'b101: result = (B == B) ? 4'b0001 : 4'b0000;   // EQ with BSE

      3'b110: result = (A < B) ? 4'b0001 : 4'b0000;    // LT
      3'b111: result = 4'b0000;                       // NOP
      default: result = 4'b0000;                      // safety
    endcase

    zero_flag = (result == 4'b0000);
  end

endmodule