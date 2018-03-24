//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : tft_ctrl.v
// Author        : XuJYC
// Created On    : 2018-01-30 15:37
// Last Modified : 2018-01-30 15:37
// Version       : v1.0
// Description   : None
//
// RGB565
// 800 x 480
//-------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tft_800x480_16bit
(
    input         rstn        ,
    input         clk         , // 33MHz

    input  [15:0] tft_data_in ,
    output [15:0] tft_rgb     , // TFT RGB565
    output        tft_hs      ,
    output        tft_vs      ,
    output        tft_clk     ,
    output        tft_de      ,
    output        tft_pwm     ,

    output [11:0] hs_cnt      ,
    output [11:0] vs_cnt
);

reg [11:0] hs_cnt_r;
reg [11:0] vs_cnt_r;

// 800 x 480
localparam TFT_HS_SYNC_END   = 11'd1    ;
localparam TFT_VS_SYNC_END   = 11'd1    ;
localparam TFT_HS_DATA_BEGIN = 11'd46   ;
localparam TFT_HS_DATA_END   = 11'd846  ;
localparam TFT_VS_DATA_BEGIN = 11'd24   ;
localparam TFT_VS_DATA_END   = 11'd504  ;
localparam TFT_HS_PIX_END    = 11'd1056 ;
localparam TFT_VS_LINE_END   = 11'd524  ;


assign tft_de =
    ((hs_cnt_r>=TFT_HS_DATA_BEGIN) && (hs_cnt_r<TFT_HS_DATA_END)) &&
    ((vs_cnt_r>=TFT_VS_DATA_BEGIN) && (vs_cnt_r<TFT_VS_DATA_END));

assign hs_cnt = tft_de ? (hs_cnt_r - TFT_HS_DATA_BEGIN) : 12'd0;
assign vs_cnt = tft_de ? (vs_cnt_r - TFT_VS_DATA_BEGIN) : 12'd0;

//--> TFT ctrl
assign tft_clk = clk;
assign tft_hs  = (hs_cnt_r>TFT_HS_SYNC_END);
assign tft_vs  = (vs_cnt_r>TFT_VS_SYNC_END);
assign tft_rgb = (tft_de) ? tft_data_in : 16'h0000;
assign tft_pwm = 1'b1;
//<--

// hs scan cnt
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        hs_cnt_r <= 'd0;
    end
    //else if(hs_cnt_r == TFT_HS_SYNC_END)
    else if(hs_cnt_r == TFT_HS_PIX_END)
    begin
        hs_cnt_r <= 'd0;
    end
    else
    begin
        hs_cnt_r <= hs_cnt_r + 1'd1;
    end
end
// vs scan cnt
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        vs_cnt_r <= 'd0;
    end
    //else if(hs_cnt_r == TFT_HS_SYNC_END)
    else if(hs_cnt_r == TFT_HS_PIX_END)
    begin
        //if(vs_cnt_r == TFT_VS_SYNC_END)
        if(vs_cnt_r == TFT_VS_LINE_END)
        begin
            vs_cnt_r <= 'd0;
        end
        else
        begin
            vs_cnt_r <= vs_cnt_r + 1'b1;
        end
    end
    else
    begin
        vs_cnt_r <= vs_cnt_r;
    end
end

endmodule

