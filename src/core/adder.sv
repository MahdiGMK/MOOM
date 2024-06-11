module adder #(
    parameter int NBIT = 10
) ();

  genvar i;
  generate
    for (i = 0; i < NBIT; i = i + 1) begin : g_test

    end
  endgenerate



endmodule
