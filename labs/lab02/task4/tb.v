module tb;

  reg [1:0] t_a, t_b;
  wire y_df, y_before, y_intra;

  and_df U_DF (.a(t_a), .b(t_b), .y(y_df));
  and_beh_before U_BEFORE (.a(t_a), .b(t_b), .y(y_before));
  and_beh_intra U_INTRA (.a(t_a), .b(t_b), .y(y_intra));

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, tb);
    end
  end

  // Each gate has a #5 delay somewhere in its own implementation. Toggle
  // the inputs every 2 time units — faster than that S-unit delay — so
  // that any implementation using state values will show it.
  initial begin
    t_a = 0; t_b = 0;
    #2 t_a = 1; t_b = 0;
    #2 t_a = 1; t_b = 1;
    #2 t_a = 0; t_b = 1;
    #2 t_a = 1; t_b = 1;
    #2 t_a = 0; t_b = 0;
    #2 t_a = 1; t_b = 1;
    #2 t_a = 0; t_b = 0;
    #10 $finish;
  end

  initial
    $monitor($time, " a=%b b=%b | df=%b before=%b intra=%b",
      t_a, t_b, y_df, y_before, y_intra);

endmodule