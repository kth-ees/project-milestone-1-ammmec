module alu #(
  BW = 16 // bitwidth
  ) (
  input  logic signed [BW-1:0] in_a,
  input  logic signed [BW-1:0] in_b,
  input  logic             [3:0] opcode,
  output logic signed [BW-1:0] out,
  output logic             [2:0] flags // {overflow, negative, zero}
  );

  typedef enum logic [3:0] {ADD, SUB, AND, OR, XOR, INC, MOVA, MOVB} code;
  typedef enum logic [1:0] {Z, NEG, OVF} flag;

  always_comb begin : decode
    case (opcode)
      ADD     :  out = in_a + in_b;
      SUB     :  out = in_a - in_b;
      AND     :  out = in_a & in_b;
      OR      :  out = in_a | in_b;
      XOR     :  out = in_a ^ in_b;
      INC     :  out = in_a + 1;
      MOVA    :  out = in_a;
      MOVB    :  out = in_b;
      default :  out = '0;
    endcase
  end

  always_comb begin : overflowDetector
    flags[OVF] = '0;
    if (opcode == ADD) begin
      flags[OVF] = (!in_a[BW-1] & !in_b[BW-1] &  out[BW-1]) ||  // A >= 0 & B >= 0, ovf if OUT < 0
                   ( in_a[BW-1] &  in_b[BW-1] & !out[BW-1]);    // A < 0  & B < 0,  ovf if OUT >= 0
    end
    else if (opcode == SUB) begin
      flags[OVF] = (!in_a[BW-1] &  in_b[BW-1] &  out[BW-1]) ||  // A >= 0 & B < 0,  ovf if OUT < 0
                   ( in_a[BW-1] & !in_b[BW-1] & !out[BW-1]);    // A < 0  & B >= 0, ovf if OUT >= 0
    end
  end

  assign flags[NEG] = (out[BW-1]); // MSB of the output determines if it's negative
  assign flags[Z]   = !(out);

endmodule




