`timescale 1 ns / 1 ps

module ml_model_stage3 (
    input [124:0] model_inp,
    output [85:0] model_out
);

    // verilator lint_off UNUSEDSIGNAL
    // Explicit quantization operation will drop bits if exists

    wire [8:0] v0; assign v0[8:0] = model_inp[8:0]; // 30.0
    wire [8:0] v1; assign v1[8:0] = model_inp[17:9]; // 30.0
    wire [9:0] v2; shift_adder #(9, 9, 0, 0, 10, 0, 0) op_2 (v0[8:0], v1[8:0], v2[9:0]); // 31.0
    wire [8:0] v3; assign v3[8:0] = model_inp[26:18]; // 30.0
    wire [8:0] v4; assign v4[8:0] = model_inp[35:27]; // 30.0
    wire [9:0] v5; shift_adder #(9, 9, 0, 0, 10, 0, 0) op_5 (v3[8:0], v4[8:0], v5[9:0]); // 31.0
    wire [8:0] v6; assign v6[8:0] = model_inp[44:36]; // 30.0
    wire [10:0] v7; shift_adder #(9, 10, 0, 0, 11, 0, 0) op_7 (v6[8:0], v5[9:0], v7[10:0]); // 32.0
    wire [11:0] v8; shift_adder #(10, 11, 0, 0, 12, 0, 0) op_8 (v2[9:0], v7[10:0], v8[11:0]); // 33.0
    wire [11:0] v9; shift_adder #(12, 6, 0, 0, 12, 0, 0) op_9 (v8[11:0], 6'b100000, v9[11:0]); // 33.0
    wire [5:0] v10; assign v10[5:0] = v9[11:6]; // 33.0
    wire [5:0] v11; lookup_table #(6, 6, "table_32c13eaf-a8f7-4ca3-b1f5-c6a30a038dd5.mem") op_11 (v10, v11[5:0]); // 34.0
    wire [7:0] v12; assign v12[7:0] = model_inp[52:45]; // 30.0
    wire [7:0] v13; assign v13[7:0] = model_inp[60:53]; // 30.0
    wire [7:0] v14; assign v14[7:0] = model_inp[68:61]; // 30.0
    wire [7:0] v15; assign v15[7:0] = model_inp[76:69]; // 30.0
    wire [7:0] v16; assign v16[7:0] = model_inp[84:77]; // 30.0
    wire [7:0] v17; assign v17[7:0] = model_inp[92:85]; // 30.0
    wire [7:0] v18; assign v18[7:0] = model_inp[100:93]; // 30.0
    wire [7:0] v19; assign v19[7:0] = model_inp[108:101]; // 30.0
    wire [7:0] v20; assign v20[7:0] = model_inp[116:109]; // 30.0
    wire [7:0] v21; assign v21[7:0] = model_inp[124:117]; // 30.0

    // verilator lint_on UNUSEDSIGNAL

    assign model_out[7:0] = v12[7:0];
    assign model_out[13:8] = v11[5:0];
    assign model_out[21:14] = v13[7:0];
    assign model_out[29:22] = v14[7:0];
    assign model_out[37:30] = v15[7:0];
    assign model_out[45:38] = v16[7:0];
    assign model_out[53:46] = v17[7:0];
    assign model_out[61:54] = v18[7:0];
    assign model_out[69:62] = v19[7:0];
    assign model_out[77:70] = v20[7:0];
    assign model_out[85:78] = v21[7:0];

    endmodule
