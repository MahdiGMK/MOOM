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

    fp32_t de_normal[16];
    fp32_t pinf, ninf, nan;

    logic [3:0] i, j;

    initial begin
        pinf.value = {
            1'b0, 11'b11111111111, 52'b0000000000000000000000000000000000000000000000000000
        };
        ninf.value = {
            1'b1, 11'b11111111111, 52'b0000000000000000000000000000000000000000000000000000
        };
        nan.value = {
            1'b0, 11'b11111111111, 52'b1000000000000000000000000000000000000000000000000000
        };

        de_normal[0].value = {
            1'b0, 11'b00000000000, 52'b1111111111111111111000000000000000000000000000000000
        };
        de_normal[1].value = {
            1'b0, 11'b00000000000, 52'b0000000111111111111111110000000000000000000000000000
        };
        de_normal[2].value = {
            1'b0, 11'b00000000000, 52'b0000000000000111111111111111111100000000000000000000
        };
        de_normal[3].value = {
            1'b0, 11'b00000000000, 52'b0000000000000000000111111111111111111110000000000000
        };
        de_normal[4].value = {
            1'b0, 11'b00000000000, 52'b0000000000000000000000000000011111111111111111100000
        };
        de_normal[5].value = {
            1'b0, 11'b00000000000, 52'b0000000000000000000000000000000000011111111111111111
        };

        de_normal[6].value = {
            1'b0, 11'b00000000001, 52'b1111111111111111111111111100000000000000000000000000
        };
        de_normal[7].value = {
            1'b0, 11'b00000000001, 52'b0000000000111111111111111111111111100000000000000000
        };
        de_normal[8].value = {
            1'b0, 11'b00000000001, 52'b0000000000000000000000000000111111111111111111111111
        };
        de_normal[9].value = {
            1'b0, 11'b00000000011, 52'b1111111111111110000000000000000000000000000000000000
        };
        de_normal[10].value = {
            1'b0, 11'b00000000010, 52'b0000000000001111111111111111111111111111000000000000
        };
        de_normal[11].value = {
            1'b0, 11'b00000000011, 52'b0000000000000000000000000000000011111111111111111111
        };


        de_normal[12].value = {
            1'b0, 11'b11111111110, 52'b1111111111111111111111111111111111111111111111111111
        };
        de_normal[13].value = {
            1'b0, 11'b11111001001, 52'b1111111111111111111111111111111111111111111111111111
        };
        de_normal[14].value = {
            1'b0, 11'b11111001000, 52'b1111111111111111111111111111111111111111111111111111
        };
        de_normal[15].value = {
            1'b0, 11'b11111000111, 52'b1111111111111111111111111111111111111111111111111111
        };

        a.fpvalue = 1;
        b.fpvalue = 2;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true = %f", (a.fpvalue + b.fpvalue));

        a = pinf;
        b = ninf;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true = %f", (a.fpvalue + b.fpvalue));

        a = pinf;
        b = pinf;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true = %f", (a.fpvalue + b.fpvalue));

        a = ninf;
        b = ninf;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true = %f", (a.fpvalue + b.fpvalue));

        a = nan;
        b = pinf;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true = %f", (a.fpvalue + b.fpvalue));

        a = ninf;
        b = nan;
        #1 $display("%f + %f = %f", a.fpvalue, b.fpvalue, out.fpvalue);
        $display("true = %f", (a.fpvalue + b.fpvalue));

        i = 0;
        repeat (16) begin
            j = 0;
            repeat (16) begin
                addnot_sub = 0;
                a = de_normal[i];
                b = de_normal[j];
                #1
                $display(
                    "%20e + %20e = %20e vs %20e : judgement : %b",
                    a.fpvalue,
                    b.fpvalue,
                    out.fpvalue,
                    (a.fpvalue + b.fpvalue),
                    (a.fpvalue + b.fpvalue) == out.fpvalue
                );
                addnot_sub = 1;
                #1
                $display(
                    "%20e + %20e = %20e vs %20e : judgement : %b",
                    a.fpvalue,
                    b.fpvalue,
                    out.fpvalue,
                    (a.fpvalue - b.fpvalue),
                    (a.fpvalue - b.fpvalue) == out.fpvalue
                );

                j = j + 1;
            end
            i = i + 1;
        end
    end

endmodule
