/*
 * Copyright (c) 2024 Satvik Gonur
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_sgonur_mac (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  wire [3:0] A_in  = ui_in[3:0];
  wire [3:0] B_in  = ui_in[7:4];
  wire start_bit   = uio_in[0];

  wire [7:0] result;
  wire done_bit;

  mac_core u_mac (
      .clk(clk),
      .rst_n(rst_n),
      .start_bit(start_bit),
      .a_i(A_in),
      .b_i(B_in),
      .c_o(result),
      .done_bit(done_bit)
  );

  assign uo_out = result;
  assign uio_out[0] = done_bit;
  assign uio_out[7:1] = 0;

  assign uio_oe[0] = 1;
  assign uio_oe[7:1] = 0;

  wire _unused = &{ena, 1'b0};

endmodule
