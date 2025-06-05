/*
  ALU with CONTROL LOGIC FAULT:
    • opcode[1] is forced to 1 (stuck-at-1).
    • We case on the "faulted" opcode instead of the real one.
*/
module alu_4bit_ctrlfault (
  input  [3:0] A,
  input  [3:0] B,
  input  [2:0] opcode,
  output reg [3:0] result,
  output reg       zero_flag
);

  // Stuck-at-1 on opcode bit1
  wire [2:0] opcode_faulted = { opcode[2], 1'b1, opcode[0] };

  always @(*) begin
    case (opcode_faulted)           // ← use the mutated opcode here
      3'b000: result = A + B;       // ADD
      3'b001: result = A - B;       // SUB
      3'b010: result = A & B;       // AND
      3'b011: result = A | B;       // OR
      3'b100: result = A ^ B;       // XOR
      3'b101: result = (A == B)
                        ? 4'b0001  // EQ
                        : 4'b0000;
      3'b110: result = (A < B)
                        ? 4'b0001  // LT
                        : 4'b0000;
      3'b111: result = 4'b0000;     // NOP
      default: result = 4'b0000;    // Safety default
    endcase

    // Zero-flag logic unchanged
    zero_flag = (result == 4'b0000);
  end

endmodule