//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : vga_gm7123.v
// Author        : XuJYC
// Created On    : 2019-02-05 10:28
// Last Modified : 2019-02-05 10:28
// Version       : v1.0
// Description   : None
//
// GM7123(Compatible with ADV7123)
// 24bits
// RGB888 supported
// 1600 * 1200 @ 60Hz
//-------------------------------------------------------------------------------

`timescale 1ns / 1ps

module vga_gm7123
(
    input         rstn        ,
    input         clk         , // 25MHz
    input  [23:0] vga_data_in ,
    output [23:0] vga_rgb     , // VGA RGB565
    output        vga_hs      ,
    output        vga_vs      ,
    output        vga_clk     ,
    output        vga_blk     ,

    output [11:0] hs_cnt      ,
    output [11:0] vs_cnt
);

reg [11:0] hs_cnt_r;
reg [11:0] vs_cnt_r;

// 800 x 480
localparam VGA_HS_SYNC_END   = 11'd95  ;
localparam VGA_VS_SYNC_END   = 11'd1   ;
localparam VGA_HS_DATA_BEGIN = 11'd143 ;
localparam VGA_HS_DATA_END   = 11'd783 ;
localparam VGA_VS_DATA_BEGIN = 11'd34  ;
localparam VGA_VS_DATA_END   = 11'd514 ;
localparam VGA_HS_PIX_END    = 11'd799 ;
localparam VGA_VS_LINE_END   = 11'd524 ;


assign data_act =
    ((hs_cnt_r>=VGA_HS_DATA_BEGIN) && (hs_cnt_r<VGA_HS_DATA_END)) &&
    ((vs_cnt_r>=VGA_VS_DATA_BEGIN) && (vs_cnt_r<VGA_VS_DATA_END));

assign hs_cnt = data_act ? (hs_cnt_r - VGA_HS_DATA_BEGIN) : 12'd0;
assign vs_cnt = data_act ? (vs_cnt_r - VGA_VS_DATA_BEGIN) : 12'd0;

//--> VGA ctrl
assign vga_clk = ~clk;
assign vga_blk = data_act;
assign vga_hs  = (hs_cnt_r>VGA_HS_SYNC_END);
assign vga_vs  = (vs_cnt_r>VGA_VS_SYNC_END);
assign vga_rgb = (data_act) ? vga_data_in : 24'h0;
//<--

// hs scan cnt
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        hs_cnt_r <= 'd0;
    end
    //else if(hs_cnt_r == VGA_HS_SYNC_END)
    else if(hs_cnt_r == VGA_HS_PIX_END)
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
    //else if(hs_cnt_r == VGA_HS_SYNC_END)
    else if(hs_cnt_r == VGA_HS_PIX_END)
    begin
        //if(vs_cnt_r == VGA_VS_SYNC_END)
        if(vs_cnt_r == VGA_VS_LINE_END)
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
