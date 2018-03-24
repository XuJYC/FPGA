//-------------------------------------------------------------------------------
// Created by    : XuJYC
// Filename      : uart_tx.v
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
module uart_tx
(
    input            clk          ,
    input            rstn         ,
    input            uart_trig    ,
    input      [7:0] uart_tx_data ,
    output           uart_tx_busy ,
    output reg       uart_tx
);
//-------------------------------------------------------------------------------
//localparam BAUD_END    = 40           ; // just for simulation
localparam BAUD_END    = 434            ;
localparam BAUD_MIDDLE = BAUD_END/2 - 1 ;
localparam BIT_END     = 8              ;
//-------------------------------------------------------------------------------
reg [ 7:0] uart_tx_data_r ;
reg        tx_flag        ;
reg        bit_flag       ;
reg [ 3:0] bit_cnt        ;
reg [12:0] baud_cnt       ;
//-------------------------------------------------------------------------------
assign uart_tx_busy = tx_flag;
//-------------------------------------------------------------------------------
// register uart_tx_data
always@(posedge clk, negedge rstn)
begin
    if(rstn == 1'b0)
    begin
        uart_tx_data_r <= 'd0;
    end
    else if(uart_trig == 1'b1 && tx_flag == 1'b0)
    begin
        uart_tx_data_r <= uart_tx_data;
    end
    else
    begin
        uart_tx_data_r <= uart_tx_data_r;
    end
end
//-------------------------------------------------------------------------------
//  tx_flag goes HIGH after uart_trig
always@(posedge clk, negedge rstn)
begin
    if(rstn == 1'b0)
    begin
        tx_flag <= 1'b0;
    end
    else if(uart_trig == 1'b1)
    begin
        tx_flag <= 1'b1;
    end
    else if(bit_cnt == BIT_END && bit_flag == 1'b1)
    begin
        tx_flag <= 1'b0;
    end
    else
    begin
        tx_flag <= tx_flag;
    end
end
//-------------------------------------------------------------------------------
// baud_cnt++ when tx_flag is HIGH
always@(posedge clk, negedge rstn)
begin
    if(rstn == 1'b0)
    begin
        baud_cnt <= 'd0;
    end
    else if(baud_cnt == BAUD_END)
    begin
        baud_cnt <= 'd0;
    end
    else if(tx_flag == 1'b1)
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
    if(rstn == 1'b0)
    begin
        bit_flag <= 1'b0;
    end
    else if(baud_cnt == BAUD_END)
    begin
        bit_flag <= 1'b1;
    end
    else
    begin
        bit_flag <= 1'b0;
    end
end
//-------------------------------------------------------------------------------
// bit_cnt++ when bit_flag goes HIGH every time
always@(posedge clk, negedge rstn)
begin
    if(rstn == 1'b0)
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
// uart_tx transfer flow
always@(posedge clk, negedge rstn)
begin
    if(rstn == 1'b0)
    begin
        uart_tx <= 1'b1;
    end
    else if(tx_flag == 1'b1)
    begin
        case(bit_cnt)
            0: uart_tx <= 1'b0; // start bit
            1: uart_tx <= uart_tx_data_r[0];
            2: uart_tx <= uart_tx_data_r[1];
            3: uart_tx <= uart_tx_data_r[2];
            4: uart_tx <= uart_tx_data_r[3];
            5: uart_tx <= uart_tx_data_r[4];
            6: uart_tx <= uart_tx_data_r[5];
            7: uart_tx <= uart_tx_data_r[6];
            8: uart_tx <= uart_tx_data_r[7];
            default:uart_tx <= 1'b1;
        endcase
    end
    else
    begin
        uart_tx <= 1'b1;
    end
end
//-------------------------------------------------------------------------------
endmodule

