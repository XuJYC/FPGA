//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : vga_test.v
// Author        : XuJYC
// Created On    : 2019-02-05 11:21
// Last Modified : 2019-02-05 11:21
// Version       : v1.0
// Description   : None
//
//
//-------------------------------------------------------------------------------

`timescale 1ns / 1ps

module vga_test
(
    input         rstn     ,
    input         clk      ,

    output [23:0] vga_rgb  , // vga RGB565
    output        vga_hs   ,
    output        vga_vs   ,
    output        vga_clk  ,
    output        vga_blk
);

wire [11:0] hs_cnt         ;
wire [11:0] vs_cnt         ;
reg  [23:0] color_bar_data ;
wire [23:0] vga_data_in    ;
wire [ 7:0] row_col_act    ;

//-------------------------------------------------------------------------------
localparam BLACK   = 24'h000000;
localparam BLUE    = 24'h00000F;
localparam RED     = 24'hFF0000;
localparam PURPPLE = 24'hFF00FF;
localparam GREEN   = 24'h00FF00;
localparam CYAN    = 24'h00FFFF;
localparam YELLOW  = 24'hFFFF00;
localparam WHITE   = 24'hFFFFFF;

localparam R0_C0 = BLACK   ;
localparam R0_C1 = BLUE    ;
localparam R1_C0 = RED     ;
localparam R1_C1 = PURPPLE ;
localparam R2_C0 = GREEN   ;
localparam R2_C1 = CYAN    ;
localparam R3_C0 = YELLOW  ;
localparam R3_C1 = WHITE   ;


wire r0_act = vs_cnt >=   0 && vs_cnt < 120; // row 1
wire r1_act = vs_cnt >= 120 && vs_cnt < 240; // row 2
wire r2_act = vs_cnt >= 240 && vs_cnt < 360; // row 3
wire r3_act = vs_cnt >= 360 && vs_cnt < 480; // row 4

wire c0_act = hs_cnt >=   0 && hs_cnt < 320; // col 1
wire c1_act = hs_cnt >= 320 && hs_cnt < 640; // col 2

wire r0_c0_act = r0_act & c0_act; // 0 0
wire r0_c1_act = r0_act & c1_act; // 0 1
wire r1_c0_act = r1_act & c0_act; // 1 0
wire r1_c1_act = r1_act & c1_act; // 1 1
wire r2_c0_act = r2_act & c0_act; // 2 0
wire r2_c1_act = r2_act & c1_act; // 2 1
wire r3_c0_act = r3_act & c0_act; // 3 0
wire r3_c1_act = r3_act & c1_act; // 3 1

assign vga_data_in = color_bar_data;

assign row_col_act = {r3_c1_act,r3_c0_act,r2_c1_act,r2_c0_act,r1_c1_act,r1_c0_act,r0_c1_act,r0_c0_act};

always@(*)
begin
    case({row_col_act})
        8'b0000_0001: color_bar_data = R0_C0;
        8'b0000_0010: color_bar_data = R0_C1;
        8'b0000_0100: color_bar_data = R1_C0;
        8'b0000_1000: color_bar_data = R1_C1;
        8'b0001_0000: color_bar_data = R2_C0;
        8'b0010_0000: color_bar_data = R2_C1;
        8'b0100_0000: color_bar_data = R3_C0;
        8'b1000_0000: color_bar_data = R3_C1;
        default     : color_bar_data = R0_C0;
    endcase
end

//-------------------------------------------------------------------------------

vga_gm7123 u_vga_gm7123
(
    .rstn        (rstn        ),
    .clk         (clk         ), // 33MHz
    .vga_data_in (vga_data_in ),
    .vga_rgb     (vga_rgb     ), // vga RGB565
    .vga_hs      (vga_hs      ),
    .vga_vs      (vga_vs      ),
    .vga_clk     (vga_clk     ),
    .vga_blk     (vga_blk     ),
    .hs_cnt      (hs_cnt      ),
    .vs_cnt      (vs_cnt      )
);

endmodule

