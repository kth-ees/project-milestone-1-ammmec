module fpga_alu_tb (
    input logic [10:0] SW,
    output logic [7:0] D1_SEG,
    output logic [3:0] D1_AN,
    output logic [2:0] LED
);

  logic [3:0] out;

  // Instantiate the ALU
  alu #(4) dut (
    .in_a(SW[3:0]),
    .in_b(SW[7:4]),
    .opcode(SW[10:8]),
    .out(out),
    .flags(LED[2:0])
  );
  
    kw4281_driver driver (.rst_n(1'b1), .clk(CLK_100MHZ), 
                          .input_bcd(out),
                          .an(D1_AN), .seg(D1_SEG[7:0]));
endmodule