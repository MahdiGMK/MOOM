module fpseperator #(
    parameter  int N_BIT   = 32,
    parameter  int EXP_BIT = 8,
    localparam int ManBIT  = N_BIT - EXP_BIT - 1
) (
    input [N_BIT - 1:0] value,
    output logic [ManBIT - 1:0] man,
    output logic [EXP_BIT - 1:0] exp,
    output logic sign,
    output logic isNormal,
    output logic isDenormal,
    output logic isNAN,
    output logic isINF
);
    assign man = value[ManBIT-1:0];
    assign exp = value[N_BIT-2:ManBIT];
    assign sign = value[N_BIT-1];
    assign isDenormal = ~|exp;  // exp == 0
    assign isNormal = |exp && ~&exp;  // exp != 0 and exp != 1111
    assign isNAN = &exp && |man;  // exp == 1111 and man != 0
    assign isINF = &exp && ~|man;  // exp == 1111 and man == 0
endmodule
