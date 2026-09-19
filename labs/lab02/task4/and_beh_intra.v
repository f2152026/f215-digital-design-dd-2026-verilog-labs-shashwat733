module and_beh_intra (input a, b, output reg y);
  always @(*)
    y = #1 (a & b);
endmodule