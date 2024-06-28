module minifload_test;
    logic a_sign, b_sign, o_sign;
    logic [3:0] a_exp, b_exp, o_exp;
    logic [2:0] a_man, b_man, o_man;
    logic addnot_sub;
    logic clk;
    logic start;
    logic ready;

    fpmul #(
        .LOG_BIT(3),
        .EXP_BIT(4)
    ) fp (
        .a({a_sign, a_exp, a_man}),
        .b({b_sign, b_exp, b_man}),
        .out({o_sign, o_exp, o_man}),
        .ready(ready),
        .clk(clk),
        .start(start)
    );

    always #1 clk = !clk;
    initial begin
        clk = 0;

        a_sign = 1'b0;  // 3.0
        a_exp = 4'b1000;
        a_man = 3'b100;

        b_sign = 1'b0;  // 2.0
        b_exp = 4'b1000;
        b_man = 3'b000;

        start = 1;
        #2 start = 0;

        wait (ready);
        $display("%b %b %b", o_sign, o_exp, o_man);
    end
endmodule
