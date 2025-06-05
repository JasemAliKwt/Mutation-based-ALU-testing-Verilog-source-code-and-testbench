/*
  ALU with INPUT-A LOGIC FAULT:
    • Bit-2 of A is inverted whenever any operation uses A.
*/
module alu_4bit_inputA_logicfault (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] opcode,
    output reg [3:0] result,
    output reg       zero_flag
);

  // -- Inject the logic fault on A:
  //    here we invert A[2] but keep the other bits intact.
  wire [3:0] A_bad = { A[3],
                       ~A[2],  // the fault
                       A[1],
                       A[0] };

  always @(*) begin
    case (opcode)
      3'b000: result = A_bad + B;                     // ADD
      3'b001: result = A_bad - B;                     // SUB
      3'b010: result = A_bad & B;                     // AND
      3'b011: result = A_bad | B;                     // OR
      3'b100: result = A_bad ^ B;                     // XOR
      3'b101: result = (A_bad == B) ? 4'b0001 : 4'b0000; // EQ
      3'b110: result = (A_bad <  B) ? 4'b0001 : 4'b0000; // LT
      3'b111: result = 4'b0000;                       // NOP
      default: result = 4'b0000;                      // safety
    endcase

    zero_flag = (result == 4'b0000);
  end
endmodule