// 4-bit ALU (Arithmetic Logic Unit)
module alu_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  [2:0] opcode,
    output reg [3:0] result,
    output reg zero_flag
);

// Combinational logic to select operation based on opcode
always @(*) begin
    case (opcode)
        3'b000: result = A + B;                               // ADD
        3'b001: result = A - B;                               // SUB
        3'b010: result = A & B;                               // AND
        3'b011: result = A | B;                               // OR
        3'b100: result = A ^ B;                               // XOR
        3'b101: result = (A == B) ? 4'b0001 : 4'b0000;        // EQ (Equal)
        3'b110: result = (A < B)  ? 4'b0001 : 4'b0000;        // LT (Less-than)
        3'b111: result = 4'b0000;                             // NOP
        default: result = 4'b0000;                            // Default to 0
    endcase

    // Set the zero_flag if result is zero
    zero_flag = (result == 4'b0000);
end

endmodule