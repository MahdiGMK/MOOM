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

    logic isNormal[2], isDenormal[2], isINF[2], isNAN[2], sign[2];
    logic [EXP_BIT-1:0] exp[2];
    logic [MAN_BIT-1:0] man[2];
    fpseperator #(
        .NBIT(N_BIT),
        .EXP_BIT(EXP_BIT)
    ) aSep (
        .value(a),
        .isNormal(isNormal[0]),
        .isDenormal(isDenormal[0]),
        .isINF(isINF[0]),
        .isNAN(isNAN[0]),
        .sign(sign[0]),
        .exp(exp[0]),
        .man(man[0])
    );
    fpseperator #(
        .NBIT(N_BIT),
        .EXP_BIT(EXP_BIT)
    ) bSep (
        .value(b),
        .isNormal(isNormal[1]),
        .isDenormal(isDenormal[1]),
        .isINF(isINF[1]),
        .isNAN(isNAN[1]),
        .sign(sign[1]),
        .exp(exp[1]),
        .man(man[1])
    );

    logic a_sign, b_sign, out_sign;
    logic [MAN_BIT+2 + MAN_BIT+1:0] a_man, tmp_man, b_man, out_man;
    logic [EXP_BIT-1:0] a_exp, b_exp, distance, out_exp;
    parameter logic [N_BIT-1:0] P_INF = {1'b0, EXP_BIT'((1 << EXP_BIT) - 1), {MAN_BIT{1'b0}}};
    parameter logic [N_BIT-1:0] P_NAN = {
        1'b0, EXP_BIT'((1 << EXP_BIT) - 1), 1'b1, {(MAN_BIT - 1) {1'b0}}
    };
    always_comb begin : main
        // default state
        a_sign = 1'bX;
        b_sign = 1'bX;
        out_sign = 1'bX;
        a_man = {MAN_BIT + 3{1'bX}};
        b_man = {MAN_BIT + 3{1'bX}};
        out_man = {MAN_BIT + 3{1'bX}};
        a_exp = {EXP_BIT{1'bX}};
        b_exp = {EXP_BIT{1'bX}};
        out_exp = {EXP_BIT{1'bX}};
        distance = {EXP_BIT{1'bX}};
        out = {N_BIT{1'bX}};

        if (isNAN[0] || isNAN[1]) begin
            out = P_NAN;
        end
        else if (isINF[0] && isINF[1] && (sign[0] ^ sign[1] ^ addnot_sub)) begin
            out = P_NAN;
        end
        else if (isINF[0]) begin
            out = a;
        end
        else if (isINF[1]) begin
            out = b;
        end
        else begin
            if (exp[0] < exp[1]) begin
                a_sign = sign[1] ^ addnot_sub;
                a_exp  = exp[1];
                a_man  = {2'b0, isNormal[1], man[1], {MAN_BIT + 1{1'b0}}};
                b_sign = sign[0];
                b_exp  = exp[0];
                b_man  = {2'b0, isNormal[0], man[0], {MAN_BIT + 1{1'b0}}};
            end
            else begin
                a_sign = sign[0];
                a_exp  = exp[0];
                a_man  = {2'b0, isNormal[0], man[0], {MAN_BIT + 1{1'b0}}};
                b_sign = sign[1] ^ addnot_sub;
                b_exp  = exp[1];
                b_man  = {2'b0, isNormal[1], man[1], {MAN_BIT + 1{1'b0}}};
            end
            // a_exp >= b_exp
            distance = a_exp - b_exp;
            if (|distance) begin

            end
        end
    end
endmodule

