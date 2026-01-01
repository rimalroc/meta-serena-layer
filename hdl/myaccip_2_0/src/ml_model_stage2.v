`timescale 1 ns / 1 ps

module ml_model_stage2 (
    input [94:0] model_inp,
    output [124:0] model_out
);

    // verilator lint_off UNUSEDSIGNAL
    // Explicit quantization operation will drop bits if exists

    wire [5:0] v0; assign v0[5:0] = model_inp[5:0]; // 20.0
    wire [6:0] v1; assign v1[6:0] = model_inp[12:6]; // 20.0
    wire [7:0] v2; shift_adder #(6, 7, 1, 1, 8, 0, 1) op_2 (v0[5:0], v1[6:0], v2[7:0]); // 21.0
    wire [5:0] v3; assign v3[5:0] = model_inp[18:13]; // 20.0
    wire [5:0] v4; assign v4[5:0] = model_inp[24:19]; // 20.0
    wire [6:0] v5; shift_adder #(6, 6, 1, 1, 7, 0, 1) op_5 (v3[5:0], v4[5:0], v5[6:0]); // 21.0
    wire [6:0] v6; mux #(7, 6, 1, 1, 7, 0, 0) op_6 (v2[7], v1[6:0], v0[5:0], v6[6:0]); // 22.0
    wire [5:0] v7; mux #(6, 6, 1, 1, 6, 0, 0) op_7 (v5[6], v4[5:0], v3[5:0], v7[5:0]); // 22.0
    wire [6:0] v8; assign v8[6:0] = model_inp[31:25]; // 20.0
    wire [7:0] v9; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_9 (v8[6:0], v7[5:0], v9[7:0]); // 23.0
    wire [6:0] v10; mux #(6, 7, 1, 1, 7, 0, 0) op_10 (v9[7], v7[5:0], v8[6:0], v10[6:0]); // 24.0
    wire [7:0] v11; shift_adder #(7, 7, 1, 1, 8, 0, 1) op_11 (v6[6:0], v10[6:0], v11[7:0]); // 25.0
    wire [6:0] v12; mux #(7, 7, 1, 1, 7, 0, 0) op_12 (v11[7], v10[6:0], v6[6:0], v12[6:0]); // 26.0
    wire [6:0] v13; assign v13[6:0] = model_inp[38:32]; // 20.0
    wire [7:0] v14; shift_adder #(7, 7, 1, 1, 8, 0, 1) op_14 (v12[6:0], v13[6:0], v14[7:0]); // 27.0
    wire [6:0] v15; assign v15[6:0] = model_inp[45:39]; // 20.0
    wire [7:0] v16; shift_adder #(7, 7, 1, 1, 8, 0, 1) op_16 (v12[6:0], v15[6:0], v16[7:0]); // 27.0
    wire [5:0] v17; assign v17[5:0] = model_inp[51:46]; // 20.0
    wire [7:0] v18; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_18 (v12[6:0], v17[5:0], v18[7:0]); // 27.0
    wire [5:0] v19; assign v19[5:0] = model_inp[57:52]; // 20.0
    wire [7:0] v20; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_20 (v12[6:0], v19[5:0], v20[7:0]); // 27.0
    wire [5:0] v21; assign v21[5:0] = model_inp[63:58]; // 20.0
    wire [7:0] v22; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_22 (v12[6:0], v21[5:0], v22[7:0]); // 27.0
    wire [5:0] v23; assign v23[5:0] = model_inp[69:64]; // 20.0
    wire [7:0] v24; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_24 (v12[6:0], v23[5:0], v24[7:0]); // 27.0
    wire [5:0] v25; assign v25[5:0] = model_inp[75:70]; // 20.0
    wire [7:0] v26; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_26 (v12[6:0], v25[5:0], v26[7:0]); // 27.0
    wire [5:0] v27; assign v27[5:0] = model_inp[81:76]; // 20.0
    wire [7:0] v28; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_28 (v12[6:0], v27[5:0], v28[7:0]); // 27.0
    wire [5:0] v29; assign v29[5:0] = model_inp[87:82]; // 20.0
    wire [7:0] v30; shift_adder #(7, 6, 1, 1, 8, 0, 1) op_30 (v12[6:0], v29[5:0], v30[7:0]); // 27.0
    wire [6:0] v31; assign v31[6:0] = model_inp[94:88]; // 20.0
    wire [7:0] v32; shift_adder #(7, 7, 1, 1, 8, 0, 1) op_32 (v12[6:0], v31[6:0], v32[7:0]); // 27.0
    wire [7:0] v33; lookup_table #(8, 8, "table_4e44c31a-706c-4b84-a8d6-8bc509600c4d.mem") op_33 (v14, v33[7:0]); // 29.0
    wire [7:0] v34; lookup_table #(8, 8, "table_4e44c31a-706c-4b84-a8d6-8bc509600c4d.mem") op_34 (v16, v34[7:0]); // 29.0
    wire [7:0] v35; lookup_table #(8, 8, "table_ff33d04b-ce69-4326-8e54-4605d5358d46.mem") op_35 (v18, v35[7:0]); // 29.0
    wire [7:0] v36; lookup_table #(8, 8, "table_ff33d04b-ce69-4326-8e54-4605d5358d46.mem") op_36 (v20, v36[7:0]); // 29.0
    wire [7:0] v37; lookup_table #(8, 8, "table_ff33d04b-ce69-4326-8e54-4605d5358d46.mem") op_37 (v22, v37[7:0]); // 29.0
    wire [7:0] v38; lookup_table #(8, 8, "table_ff33d04b-ce69-4326-8e54-4605d5358d46.mem") op_38 (v24, v38[7:0]); // 29.0
    wire [7:0] v39; lookup_table #(8, 8, "table_ff33d04b-ce69-4326-8e54-4605d5358d46.mem") op_39 (v26, v39[7:0]); // 29.0
    wire [7:0] v40; lookup_table #(8, 8, "table_ff33d04b-ce69-4326-8e54-4605d5358d46.mem") op_40 (v28, v40[7:0]); // 29.0
    wire [7:0] v41; lookup_table #(8, 8, "table_ff33d04b-ce69-4326-8e54-4605d5358d46.mem") op_41 (v30, v41[7:0]); // 29.0
    wire [7:0] v42; lookup_table #(8, 8, "table_4e44c31a-706c-4b84-a8d6-8bc509600c4d.mem") op_42 (v32, v42[7:0]); // 29.0
    wire [8:0] v43; shift_adder #(8, 8, 0, 0, 9, 0, 0) op_43 (v34[7:0], v35[7:0], v43[8:0]); // 30.0
    wire [8:0] v44; shift_adder #(8, 8, 0, 0, 9, 0, 0) op_44 (v36[7:0], v37[7:0], v44[8:0]); // 30.0
    wire [8:0] v45; shift_adder #(8, 8, 0, 0, 9, 0, 0) op_45 (v38[7:0], v39[7:0], v45[8:0]); // 30.0
    wire [8:0] v46; shift_adder #(8, 8, 0, 0, 9, 0, 0) op_46 (v40[7:0], v41[7:0], v46[8:0]); // 30.0
    wire [8:0] v47; shift_adder #(8, 8, 0, 0, 9, 0, 0) op_47 (v33[7:0], v42[7:0], v47[8:0]); // 30.0

    // verilator lint_on UNUSEDSIGNAL

    assign model_out[8:0] = v43[8:0];
    assign model_out[17:9] = v44[8:0];
    assign model_out[26:18] = v46[8:0];
    assign model_out[35:27] = v47[8:0];
    assign model_out[44:36] = v45[8:0];
    assign model_out[52:45] = v33[7:0];
    assign model_out[60:53] = v41[7:0];
    assign model_out[68:61] = v35[7:0];
    assign model_out[76:69] = v36[7:0];
    assign model_out[84:77] = v39[7:0];
    assign model_out[92:85] = v34[7:0];
    assign model_out[100:93] = v38[7:0];
    assign model_out[108:101] = v37[7:0];
    assign model_out[116:109] = v40[7:0];
    assign model_out[124:117] = v42[7:0];

    endmodule
