module fpmul #(
    parameter int LOG_BIT = 5,
    parameter int EXP_BIT = 8,
    parameter int N_BIT   = 1 << LOG_BIT,
    parameter int MAN_BIT = N_BIT - EXP_BIT - 1
) (
    input [N_BIT - 1:0] a,
    input [N_BIT - 1:0] b,
    input clk,
    input start,
    output logic [N_BIT - 1:0] out,
    output ready
);
    parameter int EXT_MAN_BIT = 2 * MAN_BIT + 2;
    parameter logic [EXP_BIT-1:0] EXP_BIAS = (1 << (EXP_BIT - 1)) - 1;

    logic isNormal[2], isDenormal[2], isINF[2], isNAN[2], sign[2];
    logic [EXP_BIT-1:0] exp[2];
    logic [MAN_BIT-1:0] man[2];
    logic [EXT_MAN_BIT-1:0] mulOut;
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
    unsigned_multiplier #(
        .N_BIT  (MAN_BIT + 1),
        .RES_BIT(EXT_MAN_BIT)
    ) mul (
        .a({isNormal[0], man[0]}),
        .b({isNormal[1], man[1]}),
        .ready(ready),
        .clk(clk),
        .start(start),
        .out(mulOut)
    );

    logic [  EXP_BIT:0] out_exp;
    logic [MAN_BIT+1:0] out_man;

    parameter logic [N_BIT-2:0] INF = {EXP_BIT'((1 << EXP_BIT) - 1), {MAN_BIT{1'b0}}};
    parameter logic [N_BIT-2:0] NAN = {EXP_BIT'((1 << EXP_BIT) - 1), 1'b1, {(MAN_BIT - 1) {1'b0}}};

    always_comb begin
        out_man =  mulOut[EXT_MAN_BIT-1:MAN_BIT+0] + (MAN_BIT+2)'(
            mulOut[MAN_BIT] && (mulOut[MAN_BIT+1] || |mulOut[MAN_BIT-1:0])
            );
        out_exp = exp[0] + exp[1] - EXP_BIAS + EXP_BIT'(out_man[MAN_BIT+1]);
        out_man = out_man[MAN_BIT+1] ? out_man >> 1 : out_man;

        if (isNAN[0] || isNAN[1]) begin
            out = {sign[0] ^ sign[1], NAN};
        end
        else if (out_exp[EXP_BIT] || &out_exp[EXP_BIT-1:0]) begin
            out = {sign[0] ^ sign[1], INF};
        end
        else begin
            out = {sign[0] ^ sign[1], out_exp[EXP_BIT-1:0], out_man[MAN_BIT-1:0]};
        end
    end

endmodule