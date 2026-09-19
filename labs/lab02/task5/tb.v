module tb;

  reg [3:0] t_a, t_b;
  reg t_op;
  wire [3:0] t_result;

  alu DUT(
    .a(t_a),
    .b(t_b),
    .op(t_op),
    .result(t_result)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  integer errors;
  integer total;
  integer i,j;
  reg [3:0] exp_result;

  task check;
    input [3:0] a_in, b_in;
    input op_in;
    begin
      t_a = a_in;
      t_b = b_in;
      t_op = op_in;
      #5;

      if (op_in == 1'b0)
        exp_result = a_in + b_in;        // add
      else
        exp_result = a_in - b_in;        // sub, via two's complement

      total = total + 1;

      if (t_result !== exp_result) begin
        $display("FAIL at time %0t: a=%0d b=%0d op=%b got result=%0d expected=%0d",
          $time, a_in, b_in, op_in, t_result, exp_result);
        errors = errors + 1;
      end
    end
  endtask

  initial begin
    errors = 0;
    total = 0;

    check(4'd6, 4'd3, 1'b0);
    check(4'd6, 4'd3, 1'b1);
    check(4'd6, 4'd3, 1'b0);

    check(4'd9, 4'd4, 1'b1);
    check(4'd2, 4'd7, 1'b1);
    check(4'd15, 4'd1, 1'b1);
    check(4'd0, 4'd0, 1'b1);
    check(4'd5, 4'd5, 1'b1);

    check(4'd1, 4'd2, 1'b0);
    check(4'd15, 4'd15, 1'b0);
    check(4'd8, 4'd8, 1'b0);

    $write("SUMMARY: %0d / %0d passed", total - errors, total);
    if (errors == 0)
      $write(" — ALL TESTS PASSED\n");
    else
      $write(" — %0d FAILED\n", errors);

    $finish;
  end

  initial
    $monitor($time, " a=%0d b=%0d op=%b | result=%0d", t_a, t_b, t_op, t_result);

endmodule