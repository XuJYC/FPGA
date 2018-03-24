//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : ADS8321.v
// Author        : XuJYC
// Created On    : 2017-11-19 16:37
// Last Modified : 2017-11-19 16:37
// Version       : v1.0.0
// Description   : None
//
//
//ADS8321 Features:
//- bipolar input range
//- 100KHz sample rate
//- micro power
//-- 4.5mW at 100KHz
//-- 1mW   at 10KHz
// NOTE: Minimum 22 clock cycles required for 16-bit conversion.
//-------------------------------------------------------------------------------

`timescale 1ns / 1ns
//-------------------------------------------------------------------------------
module ads8321
(
    input             rstn     ,
    input             clk      ,  // 2.5MHz

    input             ad_start ,
    output            ad_busy  ,
    output reg        ad_dval  , // AD data valid

    input             ad_dout  , // ADS8321 Dout
    output            ad_dclk  ,
    output            ad_csn   ,
    output reg [15:0] ad_data
);
//-------------------------------------------------------------------------------
parameter AD_CYCLE = 21;
//-------------------------------------------------------------------------------
reg [4:0] ad_data_cnt;
reg       ad_start_flag;
//-------------------------------------------------------------------------------
assign ad_dclk = ~clk & ad_busy;  // see details in ADS8321 datasheet
assign ad_busy = ad_start_flag;
assign ad_csn  = ~ad_start_flag;
//-------------------------------------------------------------------------------
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        ad_start_flag <= 1'b0;
    end
    else if(ad_data_cnt == AD_CYCLE)
    begin
        ad_start_flag <= 1'b0;
    end
    else if(ad_start == 1'b1)
    begin
        ad_start_flag <= 1'b1;
    end
    else
    begin
        ad_start_flag <= ad_start_flag;
    end
end
//-------------------------------------------------------------------------------
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        ad_data_cnt <= 5'd0;
    end
    else if(ad_start == 1'b1)
    begin
        ad_data_cnt <= 5'd0;
    end
    else if(ad_start_flag == 1'b1 && ad_data_cnt < AD_CYCLE)
    begin
        ad_data_cnt <= ad_data_cnt + 1'b1;
    end
    else
    begin
        ad_data_cnt <= 5'd0;
    end
end
//-------------------------------------------------------------------------------
always@(posedge ad_dclk or negedge rstn)
begin
    if(!rstn)
    begin
        ad_data <= 'h0;
    end
    else if(ad_start_flag == 1'b1 && ad_data_cnt < (AD_CYCLE-1'b1))
    begin
        ad_data <= {ad_data[14:0],ad_dout};
    end
    else
    begin
        ad_data <= ad_data; // keep
    end
end
//-------------------------------------------------------------------------------
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        ad_dval <= 1'b0;
    end
    else if(ad_data_cnt == AD_CYCLE)
    begin
        ad_dval <= 1'b1;
    end
    else
    begin
        ad_dval <= 1'b0;
    end
end
//-------------------------------------------------------------------------------
endmodule

