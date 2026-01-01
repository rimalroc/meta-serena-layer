`timescale 1 ns / 1 ps

module vmodel (
    input clk,
    input [59:0] model_inp,
    output reg [69:0] model_out
);

    reg [59:0] stage0_inp;
    wire [69:0] stage0_out;

    vmodel_stage0 stage0 (.model_inp(stage0_inp), .model_out(stage0_out));

    always @(posedge clk) begin
        stage0_inp <= model_inp;
        model_out <= stage0_out;
    end
endmodule
