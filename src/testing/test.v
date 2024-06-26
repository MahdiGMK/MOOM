module test ();
    logic val;
    x _x (.val(val));
    initial begin
        $display(val);
        val = !val;
        $display(val);

    end
endmodule
// verilator lint_off DECLFILENAME
module x (
    output logic val
);
    assign val = 1;
endmodule
