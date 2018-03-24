//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : uart_top.v
// Author        : XuJYC
// Created On    : 2018-03-24 20:56
// Last Modified : 2018-03-24 20:56
// Version       : v1.0
// Description   : None
//
//
//-------------------------------------------------------------------------------
`timescale 1ns / 1ns
//-------------------------------------------------------------------------------
module uart_top
(
    input        rstn         ,
    input        clk          ,
    // usr
    input        uart_trig    ,
    input  [7:0] uart_tx_data ,
    output       uart_tx_busy ,
    output [7:0] uart_rx_data ,
    output       uart_rx_flag ,
    // uart
    output       uart_tx      ,
    input        uart_rx
);
//-------------------------------------------------------------------------------
uart_tx u_uart_tx
(
    .clk          (clk          ),
    .rstn         (rstn         ),
    .uart_trig    (uart_trig    ),
    .uart_tx_data (uart_tx_data ),
    .uart_tx_busy (uart_tx_busy ),
    .uart_tx      (uart_tx      )
);
uart_rx u_uart_rx
(
    .rstn         (rstn         ),
    .clk          (clk          ),
    .uart_rx      (uart_rx      ),
    .uart_rx_data (uart_rx_data ),
    .uart_rx_flag (uart_rx_flag )
);
//-------------------------------------------------------------------------------
endmodule

