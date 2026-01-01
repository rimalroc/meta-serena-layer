`timescale 1 ns / 1 ps

module ml_model_stage4 (
    input [85:0] model_inp,
    output [139:0] model_out
);

    // verilator lint_off UNUSEDSIGNAL
    // Explicit quantization operation will drop bits if exists

    wire [7:0] v0; assign v0[7:0] = model_inp[7:0]; // 40.0
    wire [5:0] v1; assign v1[5:0] = model_inp[13:8]; // 40.0
    wire [13:0] v2; multiplier #(8, 6, 0, 0, 14) op_2 (v0[7:0], v1[5:0], v2[13:0]); // 42.0
    wire [7:0] v3; assign v3[7:0] = model_inp[21:14]; // 40.0
    wire [13:0] v4; multiplier #(8, 6, 0, 0, 14) op_4 (v3[7:0], v1[5:0], v4[13:0]); // 42.0
    wire [7:0] v5; assign v5[7:0] = model_inp[29:22]; // 40.0
    wire [13:0] v6; multiplier #(8, 6, 0, 0, 14) op_6 (v5[7:0], v1[5:0], v6[13:0]); // 42.0
    wire [7:0] v7; assign v7[7:0] = model_inp[37:30]; // 40.0
    wire [13:0] v8; multiplier #(8, 6, 0, 0, 14) op_8 (v7[7:0], v1[5:0], v8[13:0]); // 42.0
    wire [7:0] v9; assign v9[7:0] = model_inp[45:38]; // 40.0
    wire [13:0] v10; multiplier #(8, 6, 0, 0, 14) op_10 (v9[7:0], v1[5:0], v10[13:0]); // 42.0
    wire [7:0] v11; assign v11[7:0] = model_inp[53:46]; // 40.0
    wire [13:0] v12; multiplier #(8, 6, 0, 0, 14) op_12 (v11[7:0], v1[5:0], v12[13:0]); // 42.0
    wire [7:0] v13; assign v13[7:0] = model_inp[61:54]; // 40.0
    wire [13:0] v14; multiplier #(8, 6, 0, 0, 14) op_14 (v13[7:0], v1[5:0], v14[13:0]); // 42.0
    wire [7:0] v15; assign v15[7:0] = model_inp[69:62]; // 40.0
    wire [13:0] v16; multiplier #(8, 6, 0, 0, 14) op_16 (v15[7:0], v1[5:0], v16[13:0]); // 42.0
    wire [7:0] v17; assign v17[7:0] = model_inp[77:70]; // 40.0
    wire [13:0] v18; multiplier #(8, 6, 0, 0, 14) op_18 (v17[7:0], v1[5:0], v18[13:0]); // 42.0
    wire [7:0] v19; assign v19[7:0] = model_inp[85:78]; // 40.0
    wire [13:0] v20; multiplier #(8, 6, 0, 0, 14) op_20 (v19[7:0], v1[5:0], v20[13:0]); // 42.0

    // verilator lint_on UNUSEDSIGNAL

    assign model_out[13:0] = v2[13:0];
    assign model_out[27:14] = v4[13:0];
    assign model_out[41:28] = v6[13:0];
    assign model_out[55:42] = v8[13:0];
    assign model_out[69:56] = v10[13:0];
    assign model_out[83:70] = v12[13:0];
    assign model_out[97:84] = v14[13:0];
    assign model_out[111:98] = v16[13:0];
    assign model_out[125:112] = v18[13:0];
    assign model_out[139:126] = v20[13:0];

    endmodule
