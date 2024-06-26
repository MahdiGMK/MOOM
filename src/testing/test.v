module test ();
    logic [1:0] x;
    initial begin
        x = 2;
        x = x + 2 - 1;
        $display(x);
    end
endmodule
// verilator lint_off DECLFILENAME
