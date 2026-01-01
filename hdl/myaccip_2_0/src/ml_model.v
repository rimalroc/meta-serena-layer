`timescale 1 ns / 1 ps

module ml_model (
    input clk,
    input [119:0] model_inp,
    output reg [139:0] model_out
);

    reg [119:0] stage0_inp;
    reg [286:0] stage1_inp;
    reg [94:0] stage2_inp;
    reg [124:0] stage3_inp;
    reg [85:0] stage4_inp;
    wire [286:0] stage0_out;
    wire [94:0] stage1_out;
    wire [124:0] stage2_out;
    wire [85:0] stage3_out;
    wire [139:0] stage4_out;

    ml_model_stage0 stage0 (.model_inp(stage0_inp), .model_out(stage0_out));
    ml_model_stage1 stage1 (.model_inp(stage1_inp), .model_out(stage1_out));
    ml_model_stage2 stage2 (.model_inp(stage2_inp), .model_out(stage2_out));
    ml_model_stage3 stage3 (.model_inp(stage3_inp), .model_out(stage3_out));
    ml_model_stage4 stage4 (.model_inp(stage4_inp), .model_out(stage4_out));

    always @(posedge clk) begin
        stage0_inp <= model_inp;
        stage1_inp <= stage0_out;
        stage2_inp <= stage1_out;
        stage3_inp <= stage2_out;
        stage4_inp <= stage3_out;
        model_out <= stage4_out;
    end
endmodule
