module fpadder_test ();
    typedef union {
        logic [63:0] value;
        real fpvalue;
    } fp32_t;

    fp32_t a, b, out;
    logic addnot_sub;

    fpaddsub #(
        .NBIT(64),
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
        #1;
        $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("%b", a.value);
        $display("%b", b.value);
        $display("%b", out.value);
    end

endmodule
