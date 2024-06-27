module fpadder_test ();
    typedef union {
        logic [63:0] value;
        real fpvalue;
    } fp32_t;

    fp32_t a, b, out, true_val;
    logic addnot_sub;
    logic clk;
    logic start;
    logic ready;

    fpmul #(
        .LOG_BIT(6),
        .EXP_BIT(11)
    ) fp (
        .a(a.value),
        .b(b.value),
        .out(out.value),
        .ready(ready),
        .clk(clk),
        .start(start)
    );

    fp32_t de_normal[20];
    fp32_t pinf, ninf, nan;

    logic [4:0] i, j;
    real tres;

    always #1 clk = !clk;
    initial begin
        clk = 0;
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
            1'b0, 11'b01111111111, 52'b0001111111100000000000000000111111111111111111111111
        };
        de_normal[13].value = {
            1'b0, 11'b10000000011, 52'b1111111111111110000000000000000000000000000000000000
        };
        de_normal[14].value = {
            1'b0, 11'b00111111111, 52'b0011110000001111111111111111111111111111000000000000
        };
        de_normal[15].value = {
            1'b0, 11'b10000000001, 52'b0000111111111100000000000000000011111111111111111111
        };


        de_normal[16].value = {
            1'b0, 11'b11111111110, 52'b1111111111111111111111111111111111111111111111111111
        };
        de_normal[17].value = {
            1'b0, 11'b11111001001, 52'b1111111111111111111111111111111111111111111111111111
        };
        de_normal[18].value = {
            1'b0, 11'b11111001000, 52'b1111111111111111111111111111111111111111111111111111
        };
        de_normal[19].value = {
            1'b0, 11'b11111000111, 52'b1111111111111111111111111111111111111111111111111111
        };

        a.fpvalue = 1;
        b.fpvalue = 2;
        tres = (a.fpvalue + 0.0) * (b.fpvalue + 0.0);
        start = 1;
        #2 start = 0;
        wait (ready);
        $display("%f * %f = %f vs %f", a.fpvalue, b.fpvalue, out.fpvalue, tres);

        a = pinf;
        b = ninf;
        tres = (a.fpvalue + 0.0) * (b.fpvalue + 0.0);
        start = 1;
        #2 start = 0;
        wait (ready);
        $display("%f * %f = %f vs %f", a.fpvalue, b.fpvalue, out.fpvalue, tres);

        a = nan;
        b = ninf;
        tres = (a.fpvalue + 0.0) * (b.fpvalue + 0.0);
        start = 1;
        #2 start = 0;
        wait (ready);
        $display("%f * %f = %f vs %f", a.fpvalue, b.fpvalue, out.fpvalue, tres);

        a.fpvalue = 0;
        b = ninf;
        tres = (a.fpvalue + 0.0) * (b.fpvalue + 0.0);
        start = 1;
        #2 start = 0;
        wait (ready);
        $display("%f * %f = %f vs %f", a.fpvalue, b.fpvalue, out.fpvalue, tres);

        i = 0;
        repeat (20) begin
            j = 0;
            repeat (20) begin
                a = de_normal[i];
                b = de_normal[j];
                tres = (a.fpvalue + 0.0) * (b.fpvalue + 0.0);
                // tres = 1.0 * a.fpvalue * b.fpvalue;
                start = 1;
                #2 start = 0;
                wait (ready)
                    $display(
                        "%d,%d : ",
                        i,
                        j,
                        "%20e * %20e = %20e vs %20e : judgement : %b",
                        a.fpvalue,
                        b.fpvalue,
                        out.fpvalue,
                        tres,
                        tres == out.fpvalue,
                        // "\n --- dbg --- \n a %b\n b %b\n omul %b\n oman %b\n oexp %b\n rman %b",
                        // a.value,
                        // b.value,
                        // fp.mulOut,
                        // fp.out_man,
                        // fp.out_exp,
                        // fp.res_man
                    );
                j = j + 1;
            end
            i = i + 1;
        end
    end

endmodule
