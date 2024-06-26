module unsigned_multiplier #(
    parameter int N_BIT   = 32,
    parameter int RES_BIT = N_BIT * 2
) (
    input [N_BIT-1:0] a,
    input [N_BIT-1:0] b,
    input start,
    input clk,
    output logic [RES_BIT-1:0] out,
    output logic ready
);

    logic [  N_BIT-1:0] ra;
    logic [RES_BIT-1:0] rb;
    always_ff @(clk) begin
        if (start) begin
            ra <= a >> 1;
            rb <= RES_BIT'(b) << 1;
            out <= a[0] ? RES_BIT'(b) : RES_BIT'(0);
            ready <= ~|a[N_BIT-1:1];
        end
        else begin
            ra <= ra >> 1;
            rb <= rb << 1;
            out <= ra[0] ? out + rb : out;
            ready <= ~|ra[N_BIT-1:1];
        end
    end

endmodule
