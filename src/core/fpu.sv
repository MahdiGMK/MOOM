module fpu #(
    parameter int LOG_BIT = 5,
    parameter int EXP_BIT = 8,
    parameter int N_BIT   = 1 << LOG_BIT,
    parameter int MAN_BIT = N_BIT - EXP_BIT - 1
) (
    input [N_BIT - 1:0] a,
    input [N_BIT - 1:0] b,
    input clk,
    input [1:0] op,
    output logic [N_BIT - 1:0] out,
    output ready
);

    logic [1:0] lastOp;
    logic [N_BIT-1:0] addsub_out, mul_out;
    logic mul_ready;
    logic start = op != lastOp;  //?
    assign ready = ~op[1] | mul_ready;
    assign out   = op[1] ? mul_out : addsub_out;
    fpaddsub #(
        .LOG_BIT(LOG_BIT),
        .EXP_BIT(EXP_BIT)
    ) addsub (
        .a(a),
        .b(b),
        .addnot_sub(op[0]),
        .out(addsub_out)
    );

    fpmul #(
        .LOG_BIT(LOG_BIT),
        .EXP_BIT(EXP_BIT)
    ) mul (
        .a(a),
        .b(b),
        .clk(clk),
        .ready(mul_ready),
        .start(start),
        .out(mul_out)
    );


    always_ff @(posedge clk) begin
        lastOp <= op;
    end

endmodule
