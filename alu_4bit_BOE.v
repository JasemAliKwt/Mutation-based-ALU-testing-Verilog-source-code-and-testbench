/*
  ALU with BUS-ORDER-ERROR injection:
    • Input A is permuted as {A[0], A[3], A[1], A[2]}
    • All operations use this mis-wired A_BAD instead of the true A.
*/
module alu_4bit_BOE (
  input  [3:0] A,
  input  [3:0] B,
  input  [2:0] opcode,
  output reg [3:0] result,
  output reg       zero_flag
);

  // --- BOE: scramble A's bits
  wire [3:0] A_BAD = { A[0],  // bit0→bit3
                       A[3],  // bit3→bit2
                       A[1],  // bit1→bit1
                       A[2]   // bit2→bit0
                     };

  always @(*) begin
    case (opcode)
      3'b000: result = A_BAD + B;                        // ADD
      3'b001: result = A_BAD - B;                        // SUB
      3'b010: result = A_BAD & B;                        // AND
      3'b011: result = A_BAD | B;                        // OR
      3'b100: result = A_BAD ^ B;                        // XOR
      3'b101: result = (A_BAD == B) ? 4'b0001 : 4'b0000; // EQ
      3'b110: result = (A_BAD <  B) ? 4'b0001 : 4'b0000; // LT
      3'b111: result = 4'b0000;                          // NOP
      default: result = 4'b0000;                         // safety
    endcase

    // zero-flag unchanged logic
    zero_flag = (result == 4'b0000);
  end
endmodule