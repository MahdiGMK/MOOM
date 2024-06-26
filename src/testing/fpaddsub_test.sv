module fpadder_test ();
    typedef union {
        logic [63:0] value;
        real fpvalue;
    } fp32_t;

    fp32_t a, b, out, true_val;
    logic addnot_sub;

    fpaddsub #(
        .LOG_BIT(6),
        .EXP_BIT(11)
    ) fp (
        .a(a.value),
        .b(b.value),
        .out(out.value),
        .addnot_sub(addnot_sub)
    );

    initial begin
        a.fpvalue = 1;
        b.fpvalue = 2;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);

        a.fpvalue = 123;
        b.fpvalue = -0.23234;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);

        a.value = {1'b0, 11'b00000000000, 52'b0000000000000000000000000000000000001000000000000001};
        b.value = {1'b0, 11'b00000000000, 52'b0000000000000000000000000000000000000000100001000000};
        #1 $display("%.40e + %.40e = %.40e", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true result : %0.40e", a.fpvalue + b.fpvalue);

        a.value = {1'b0, 11'b11111111110, 52'b1111111111111111111111111111111111111111111111111111};
        b.value = {1'b0, 11'b11111001001, 52'b0000000000000000000000000000000000000000000000000000};
        #1 $display("%.40e + %.40e = %.40e", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true result : %0.40e", a.fpvalue + b.fpvalue);
        // $display("%b", a.value);
        // $display("%b", b.value);
        // $display("%b", out.value);
    end

endmodule
