/*
  ALU with MISSING-CASE injection:
    • SUB  (opcode=001)  → removed  
    • OR   (opcode=011)  → removed  
    • LT   (opcode=110)  → removed  
  Those all now resolve to the default path (4'b0000).
*/
module alu_4bit_missingcase (
  input  [3:0] A,
  input  [3:0] B,
  input  [2:0] opcode,
  output reg [3:0] result,
  output reg       zero_flag
);

  always @(*) begin
    case (opcode)
      3'b000: result = A + B;                       // ADD
      //3'b001: result = A - B;                    // SUB - *injected missing*
      3'b010: result = A & B;                       // AND
      //3'b011: result = A | B;                    // OR  - *injected missing*
      3'b100: result = A ^ B;                       // XOR
      3'b101: result = (A == B) ? 4'b0001 : 4'b0000; // EQ
      //3'b110: result = (A < B)  ? 4'b0001 : 4'b0000; // LT - *injected missing*
      3'b111: result = 4'b0000;                     // NOP
      default: result = 4'b0000;                    // default path
    endcase

    // zero flag
    zero_flag = (result == 4'b0000);
  end

endmodule
