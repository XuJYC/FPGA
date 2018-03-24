//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : tb_top.v
// Author        : XuJYC
// Created On    : 2018-03-24 20:50
// Last Modified : 2018-03-24 20:50
// Version       : v1.0
// Description   : None
//
//
//-------------------------------------------------------------------------------
`timescale 1ns / 1ns
//-------------------------------------------------------------------------------
module tb_top();
//-------------------------------------------------------------------------------
reg        clk          ;
reg        rstn         ;
wire       uart_trig    ;
reg  [7:0] uart_tx_data ;
wire       uart_tx_busy ;
wire [7:0] uart_rx_data ;
wire       uart_rx_flag ;
wire       uart_rx      ;
wire       uart_tx      ;
reg [31:0] cnt;

initial
begin
    rstn = 0;
    clk  = 0;
    #100
    rstn = 1;
end

always #10 clk = ~clk;

assign uart_trig = (cnt == 'd24_999) ? 1'b1:1'b0;
assign uart_rx   = uart_tx;

always@(posedge clk or negedge rstn)
begin
    if(!rstn)
    begin
        cnt <= 'd0;
        uart_tx_data <= 'd0;
    end
    else if(cnt == 'd24_999)
    begin
        cnt <= 'd0;
        uart_tx_data <= uart_tx_data + 1'b1;
    end
    else
    begin
        cnt <= cnt + 1'd1;
        uart_tx_data <= uart_tx_data;
    end
end

//-------------------------------------------------------------------------------
uart_top u_uart_top
(
    .rstn         (rstn         ),
    .clk          (clk          ),
    .uart_trig    (uart_trig & ~uart_tx_busy),
    .uart_tx_data (uart_tx_data ),
    .uart_tx_busy (uart_tx_busy ),
    .uart_rx_data (uart_rx_data ),
    .uart_rx_flag (uart_rx_flag ),
    .uart_tx      (uart_tx      ),
    .uart_rx      (uart_rx      )
);
//-------------------------------------------------------------------------------
endmodule

