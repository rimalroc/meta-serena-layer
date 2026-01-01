`timescale 1 ns / 1 ps

module vmodel_wrapper (
   input clk,
    // verilator lint_off UNUSEDSIGNAL
    input [59:0] model_inp,
    // verilator lint_on UNUSEDSIGNAL
    output [69:0] model_out
);
    wire [59:0] packed_inp;
    wire [69:0] packed_out;

    assign packed_inp[59:0] = model_inp[59:0];

    vmodel op (
        .clk(clk),
        .model_inp(packed_inp),
        .model_out(packed_out)
    );

    assign model_out[69:0] = packed_out[69:0];

endmodule
