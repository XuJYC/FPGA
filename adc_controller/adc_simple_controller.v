//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : adc_simple_controller.v
// Author        : XuJYC
// Created On    : 2017-11-20 20:12
// Last Modified : 2017-11-20 20:12
// Description   : a simple controller for adc with SPI interface
//
// TODO :
// 1. make it more general
// 2. add wishbone bus interface
//-------------------------------------------------------------------------------

`timescale 1ns / 1ps

//-------------------------------------------------------------------------------
`include ".\adc_defines.v"
//-------------------------------------------------------------------------------
module adc_simple_controller
(
    input                         rstn       ,
    input                         clk        ,
    input                         adc_trig   ,
    output                        adc_busy   ,
    output                        adc_dval   , // adc data valid
    output [(`ADC_DATA_WIDTH-1):0]  adc_data ,
    output                        adc_csn    , // adc interface
    output                        adc_sclk   ,
    output                        adc_sdi    , // ignore this signal if it's unused
    input                         adc_sdo
);
//-------------------------------------------------------------------------------
reg [(`ADC_CNT_WIDTH-1):0] ad_data_cnt;
reg ad_start_flag;
//-------------------------------------------------------------------------------
assign adc_busy = adc_start_flag  ;
assign adc_csn  = ~adc_start_flag ;
assign adc_sclk = ~clk & adc_busy ; // or other better way? tell me pleae
assign adc_sdi  = 1'b1            ; // See details in your adc datasheet. TODO : make it configurable
//-------------------------------------------------------------------------------
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        ad_start_flag <= 'b0;  // TODO : parameterize this signal
    end
    else if(adc_data_cnt == (`ADC_DATA_WIDTH-1))
    begin
        ad_start_flag <= 1'b0;
    end
    else if(adc_trig == 1'b1)
    begin
        adc_start_flag <= 1'b1;
    end
    else
    begin
        adc_start_flag <= adc_start_flag;
    end
end
//-------------------------------------------------------------------------------
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        adc_data_cnt <= 'd0;
    end
    else if(adc_start_flag == 1'b1 && adc_data_cnt < (`ADC_DATA_WIDTH-1))
    begin
        adc_data_cnt <= adc_data_cnt + 1'b1;
    end
    else
    begin
        adc_data_cnt <= 'd0;
    end
end
//-------------------------------------------------------------------------------
//always@(posedge clk or negedge rstn)
always@(posedge adc_sclk or negedge rstn)  // TODO : must be adc_sclk?
begin
    if(!rstn)
    begin
        ad_data <= 'd0;
    end
    //else if(adc_start_flag == 1'b1)
    else if(adc_start_flag == 1'b1 && adc_data_cnt < (`ADC_DATA_WIDTH-1))
    begin
        adc_data <= {adc_data[(`ADC_DATA_WIDTH-1):0],ad_sdo};
    end
    else
    begin
        adc_data <= adc_data;
    end
end
//-------------------------------------------------------------------------------
always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        ad_dval <= 'b0;
    end
    else if(adc_data_cnt == (`ADC_DATA_WIDTH-1))
    begin
        adc_dval <= 'b1;
    end
    else
    begin
        adc_dval <= 1'b0;
    end
end
//-------------------------------------------------------------------------------
endmodule

