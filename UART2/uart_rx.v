//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : uart_rx.v
// Author        : XuJYC
// Created On    : 2018-03-24 21:01
// Last Modified : 2018-03-24 21:01
// Version       : v1.0
// Description   : None
//
//
//-------------------------------------------------------------------------------
`timescale 1ns / 1ns
//-------------------------------------------------------------------------------
module uart_rx
(
    input            rstn         ,
    input            clk          ,
    input            uart_rx      ,
    output reg [7:0] uart_rx_data ,
    output reg       uart_rx_flag
);
//-------------------------------------------------------------------------------
//localparam BAUD_END        = 40;    // just for simulation
localparam BAUD_END        = 434;
localparam BAUD_END_MIDDLE = BAUD_END/2-1;
localparam BIT_END         = 8;
//-------------------------------------------------------------------------------
reg        uart_rx_r0      ;
reg        uart_rx_r1      ;
reg        uart_rx_r2      ;
reg        rx_flag         ;
reg        bit_flag        ; // goes HIGH at the middle of baud_cnt
reg [ 3:0] bit_cnt         ;
reg [12:0] baud_cnt        ;
wire       uart_rx_falling ;
//-------------------------------------------------------------------------------
assign uart_rx_falling = (~uart_rx_r1) & uart_rx_r2;
//-------------------------------------------------------------------------------
always@(posedge clk, negedge rstn)
begin
    if(!rstn)
    begin
        uart_rx_r0 <= 1'b0;
        uart_rx_r1 <= 1'b0;
        uart_rx_r2 <= 1'b0;
    end
    else
    begin
        uart_rx_r0 <= uart_rx;
        uart_rx_r1 <= uart_rx_r0;
        uart_rx_r2 <= uart_rx_r1;
    end
end
//-------------------------------------------------------------------------------
// rx_flag holds HIGH in complete uart receive flow
always@(posedge clk, negedge rstn)
begin
    if(!rstn)
    begin
        rx_flag <= 1'b0;
    end
    else if(uart_rx_falling == 1'b1)
    begin
        rx_flag <= 1'b1;
    end
    else if(bit_cnt == 'd0 && baud_cnt == BAUD_END)
    begin
        rx_flag <= 1'b0;
    end
    else
    begin
        rx_flag <= rx_flag;
    end
end
//-------------------------------------------------------------------------------
// baud_cnt++ while rx_flag is HIGH
always@(posedge clk, negedge rstn)
begin
    if(!rstn)
    begin
        baud_cnt <= 'd0;
    end
    else if(baud_cnt == BAUD_END)
    begin
        baud_cnt <= 'd0;
    end
    else if(rx_flag == 1'b1)
    begin
        baud_cnt <= baud_cnt + 1'b1;
    end
    else
    begin
        baud_cnt <= 'd0;
    end
end
//-------------------------------------------------------------------------------
// bit_flag goes HIGH at the middle of baud_cnt
always@(posedge clk, negedge rstn)
begin
    if(!rstn)
    begin
        bit_flag <= 1'b0;
    end
    else if(baud_cnt == BAUD_END_MIDDLE)
    begin
        bit_flag <= 1'b1;
    end
    else
    begin
        bit_flag <= 1'b0;
    end
end
//-------------------------------------------------------------------------------
// bit_cnt++ when bit_flag is HIGH every time
always@(posedge clk, negedge rstn)
begin
    if(!rstn)
    begin
        bit_cnt <= 'd0;
    end
    else if(bit_cnt == BIT_END && bit_flag == 1'b1)
    begin
        bit_cnt <= 'd0;
    end
    else if(bit_flag == 1'b1)
    begin
        bit_cnt <= bit_cnt + 1'b1;
    end
    else
    begin
        bit_cnt <= bit_cnt;
    end
end
//-------------------------------------------------------------------------------
// uart_rx_data shift
always@(posedge clk, negedge rstn)
begin
    if(rstn == 1'b0)
    begin
        uart_rx_data <= 8'd0;
    end
    else if(bit_flag == 1'b1 && bit_cnt >= 'd1)
    begin
        uart_rx_data <= {uart_rx_r2,uart_rx_data[7:1]};
    end
    else
    begin
        uart_rx_data <= uart_rx_data;
    end
end
//-------------------------------------------------------------------------------
// uart_rx_data received flag
always@(posedge clk, negedge rstn)
begin
    if(!rstn)
    begin
        uart_rx_flag <= 1'b0;
    end
    else if(bit_cnt == BIT_END && bit_flag == 1'b1)
    begin
        uart_rx_flag <= 1'b1;
    end
    else
    begin
        uart_rx_flag <= 1'b0;
    end
end
//-------------------------------------------------------------------------------
endmodule

