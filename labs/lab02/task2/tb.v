module tb;
  localparam WIDTH = 8;
  localparam DEPTH = 4;

  reg [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0] t_dout;

  // TODO: instantiate DUT here
  lut #(
    .WIDTH (WIDTH),
    .DEPTH (DEPTH)
  ) lut_inst (
    .sel (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, lut_inst);
    end
  end

  integer i;
  initial begin
    // TODO: apply different input combinations
    for (i = 0; i < DEPTH; i = i + 1) begin
      t_sel = i;
      #10;
    end
    $finish;
  end

  initial
    $monitor($time, " sel=%0d dout=%0d", t_sel, t_dout); // change as required

endmodule