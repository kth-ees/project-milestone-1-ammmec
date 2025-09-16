module alu_tb;

  parameter BW = 16; // bitwidth

  logic signed [BW-1:0] in_a;
  logic signed [BW-1:0] in_b;
  logic             [3:0] opcode;
  logic signed [BW-1:0] out;
  logic             [2:0] flags; // {overflow, negative, zero}

  // Instantiate the ALU
  alu #(BW) dut (
    .in_a(in_a),
    .in_b(in_b),
    .opcode(opcode),
    .out(out),
    .flags(flags)
  );

  logic error;
  logic signed [BW:0] ideal;

  // Generate stimuli to test the ALU
  initial begin
//    $monitor("in_a: %d, in_b: %d, opcode: %b, ovf: %b, neg: %b, zero: %b, result: %d",
//                    in_a, in_b, opcode, flags[2], flags[1], flags[0], out);
    // Flag Z test
    in_a = '0;
    in_b = '0;
    opcode = '0;
    error = '0;
    ideal = '0;
    #10ns;

    opcode = '0;
    $display("ADD");
    // Forced Overflow 1:
    in_a = '1;
    in_a[BW-1] = '0;
    in_b = '1;
    in_b[BW-1] = '0;
    #1ns;
    ideal = in_a+in_b;
    $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, ideal, out);
    error = {flags[1], out} != ideal;
    #10ns;
    // Forced overflow 2:
    in_a = '0;
    in_a[BW-1] = '1;
    in_b = '0;
    in_b[BW-1] = '1;
    #1ns;
    ideal = in_a+in_b;
    $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, ideal, out);
    error = {flags[1], out} != ideal;
    #10ns;
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      ideal = in_a+in_b;
      $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, ideal, out);
      error = {flags[1], out} != ideal;
      #10ns;
    end

    opcode = 4'b0001;
    // Forced Overflow 1:
    in_a = '1;
    in_a[BW-1] = '0;
    in_b = '0;
    in_b[BW-1] = '1;
    #1ns;
    ideal = in_a-in_b;
    $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, ideal, out);
    error = {flags[1], out} != ideal;
    #10ns;
    // Forced Overflow 2:
    in_a = '0;
    in_a[BW-1] = '1;
    in_b = '1;
    in_b[BW-1] = '0;
    #1ns;
    ideal = in_a-in_b;
    $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, ideal, out);
    error = {flags[1], out} != ideal;
    #10ns;
    $display("SUB");
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      ideal = in_a-in_b;
      $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, ideal, out);
      error = {flags[1], out} != ideal;
      #10ns;
    end

    opcode = 4'b0010;
    $display("AND");
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      ideal = in_a&in_b;
      $display("Time: %0t, Ideal Result: %0d, Out: %0d", $time, ideal, out);
      error = out != (ideal);
      #10ns;
    end

    opcode = 4'b0011;
    $display("OR");
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      $display("Time: %0t, Ideal Result: %0d, Out: %0d", $time, in_a|in_b, out);
      error = out != (in_a|in_b);
      #10ns;
    end

    opcode = 4'b0100;
    $display("XOR");
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      $display("Time: %0t, Ideal Result: %0d, Out: %0d", $time, in_a^in_b, out);
      error = out != (in_a^in_b);
      #10ns;
    end

    opcode = 4'b0101;
    $display("INC");
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, in_a+1, out);
      error = out != (in_a+1);
      #10ns;
    end

    opcode = 4'b0110;
    $display("MOVA");
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, in_a, out);
      error = out != (in_a);
      #10ns;
    end

    opcode = 4'b0111;
    $display("MOVB");
    for (int i = 0; i < 5; i++) begin
      in_a = $random;
      in_b = $random;
      #1ns;
      $display("Time: %0t, Ideal Result: %0d, Out: %d", $time, in_b, out);
      error = out != (in_b);
      #10ns;
    end
  end
endmodule
