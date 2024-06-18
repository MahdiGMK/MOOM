module fpaddsub #(
    parameter int NBIT = 32,
    parameter int EXP_BIT = 8
) (
    input [NBIT - 1:0] a,
    input [NBIT - 1:0] b,
    input addnot_sub,
    output logic [NBIT - 1:0] out
);
    localparam int ManBIT = NBIT - EXP_BIT - 1;

    fpseperator #(
        .NBIT(NBIT),
        .EXP_BIT(EXP_BIT)
    ) aSep (
        .value(a)
    );
    fpseperator #(
        .NBIT(NBIT),
        .EXP_BIT(EXP_BIT)
    ) bSep (
        .value(b)
    );

    always_comb begin : main
        if (aSep.isNAN || bSep.isNAN) begin

        end
    end
endmodule

