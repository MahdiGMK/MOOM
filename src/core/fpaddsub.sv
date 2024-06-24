module fpaddsub #(
    parameter int LOG_BIT = 5,
    parameter int EXP_BIT = 8,
    parameter int N_BIT   = 1 << LOG_BIT,
    parameter int MAN_BIT = N_BIT - EXP_BIT - 1
) (
    input [N_BIT - 1:0] a,
    input [N_BIT - 1:0] b,
    input addnot_sub,
    output logic [N_BIT - 1:0] out
);

    fpseperator #(
        .NBIT(N_BIT),
        .EXP_BIT(EXP_BIT)
    ) aSep (
        .value(a)
    );
    fpseperator #(
        .NBIT(N_BIT),
        .EXP_BIT(EXP_BIT)
    ) bSep (
        .value(b)
    );

    logic sub_oper;
    logic [MAN_BIT+2:0] a_val, tmp, b_val, out_val;
    logic [EXP_BIT-1:0] distance, out_exp;
    logic msbShifted, otherShifted, out_sign;
    always_comb begin : main
        // (de)normal system
        sub_oper = aSep.sign ^ bSep.sign ^ addnot_sub;

        a_val = {2'b00, aSep.isNormal, aSep.man};
        b_val = {2'b00, bSep.isNormal, bSep.man};
        msbShifted = 0;
        otherShifted = 0;
        if (aSep.exp < bSep.exp) begin
            distance = (bSep.exp - aSep.exp - 1);
            tmp = a_val >> distance;
            otherShifted = |((tmp << distance) ^ a_val);
            msbShifted = tmp[0];
            a_val = tmp >> 1;
            // rounding mechanism
            if (msbShifted) if (otherShifted || a_val[0] != b_val[0]) a_val = a_val + 1;

            out_exp = bSep.exp;
        end
        else if (aSep.exp > bSep.exp) begin
            distance = (aSep.exp - bSep.exp - 1);
            tmp = b_val >> distance;
            otherShifted = |((tmp << distance) ^ b_val);
            msbShifted = tmp[0];
            b_val = tmp >> 1;

            // rounding mechanism
            if (msbShifted) if (otherShifted || a_val[0] != b_val[0]) b_val = b_val + 1;

            out_exp = aSep.exp;
        end

        if (sub_oper) begin
            out_val = a_val - b_val;
        end
        else begin
            out_val = a_val + b_val;
        end

        out_sign = aSep.sign ^ out_val[MAN_BIT+2];

        if (out_val[MAN_BIT+2]) begin
            out_val = -out_val;
        end

    end
endmodule

