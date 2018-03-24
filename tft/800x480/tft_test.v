//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : tft_test.v
// Author        : XuJYC
// Created On    : 2018-01-30 16:17
// Last Modified : 2018-01-30 16:17
// Version       : v1.0
// Description   : None
//
//
//-------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tft_test
(
    input         rstn     ,
    input         clk      ,

    output [15:0] tft_rgb  , // TFT RGB565
    output        tft_hs   ,
    output        tft_vs   ,
    output        tft_clk  ,
    output        tft_de   ,
    output        tft_pwm
);

wire [11:0] hs_cnt         ;
wire [11:0] vs_cnt         ;
reg  [15:0] color_bar_data ;
wire [15:0] tft_data_in    ;

//-------------------------------------------------------------------------------
localparam BLACK   = 16'h0000;
localparam BLUE    = 16'h001F;
localparam RED     = 16'hF800;
localparam PURPPLE = 16'hF81F;
localparam GREEN   = 16'h07E0;
localparam CYAN    = 16'h07FF;
localparam YELLOW  = 16'hFFE0;
localparam WHITE   = 16'hFFFF;

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

wire c0_act = hs_cnt >=   0 && hs_cnt < 400; // col 1
wire c1_act = hs_cnt >= 400 && hs_cnt < 800; // col 2

wire r0_c0_act = r0_act & c0_act; // 0 0
wire r0_c1_act = r0_act & c1_act; // 0 1
wire r1_c0_act = r1_act & c0_act; // 1 0
wire r1_c1_act = r1_act & c1_act; // 1 1
wire r2_c0_act = r2_act & c0_act; // 2 0
wire r2_c1_act = r2_act & c1_act; // 2 1
wire r3_c0_act = r3_act & c0_act; // 3 0
wire r3_c1_act = r3_act & c1_act; // 3 1

assign tft_data_in = color_bar_data;

always@(*)
begin
    case({r3_c1_act,r3_c0_act,r2_c1_act,r2_c0_act,
        r1_c1_act,r1_c0_act,r0_c1_act,r0_c0_act})
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

tft_800x480_16bit u_tft_800x480_16bit
(
    .rstn        (rstn        ),
    .clk         (clk         ), // 33MHz
    .tft_data_in (tft_data_in ),
    .tft_rgb     (tft_rgb     ), // TFT RGB565
    .tft_hs      (tft_hs      ),
    .tft_vs      (tft_vs      ),
    .tft_clk     (tft_clk     ),
    .tft_de      (tft_de      ),
    .tft_pwm     (tft_pwm     ),
    .hs_cnt      (hs_cnt      ),
    .vs_cnt      (vs_cnt      )
);

endmodule

