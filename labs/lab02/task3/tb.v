module tb;

  reg [1:0] t_a, t_b;
  wire t_gt, t_lt, t_eq;

  reg exp_gt, exp_lt, exp_eq;

  comp2 DUT(
    .A(t_a),
    .B(t_b),
    .GT(t_gt),
    .LT(t_lt),
    .EQ(t_eq)
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

  initial begin
    errors = 0;
    total = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i[1:0];
        t_b = j[1:0];
        #5;

        // Compute expected outputs independently — plain integer
        // comparison, not a copy of the DUT's own logic.
        exp_gt = (i > j);
        exp_lt = (i < j);
        exp_eq = (i == j);

        total = total + 1;

        if ({t_gt, t_lt, t_eq} !== {exp_gt, exp_lt, exp_eq}) begin
          $display("FAIL at time %0t: A=%b B=%b got GT=%b LT=%b EQ=%b expected GT=%b LT=%b EQ=%b",
            $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
          errors = errors + 1;
        end
      end
    end

    $write("SUMMARY: %0d / %0d passed", total - errors, total);
    if (errors == 0)
      $write(" — ALL TESTS PASSED\n");
    else
      $write(" — %0d FAILED\n", errors);

    $finish;
  end

  initial
    $monitor($time, " A=%0d B=%0d | GT=%b LT=%b EQ=%b", t_a, t_b, t_gt, t_lt, t_eq);

endmodule