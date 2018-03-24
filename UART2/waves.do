
add wave -noupdate -color Red rstn
add wave -noupdate -color Yellow clk

add wave -noupdate /tb_top/u_uart_top/u_uart_tx/rstn
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/uart_trig
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/uart_tx_data
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/uart_tx_busy
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/uart_tx
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/uart_tx_data_r
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/tx_flag
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/bit_flag
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/bit_cnt
add wave -noupdate /tb_top/u_uart_top/u_uart_tx/baud_cnt
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/rstn
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/uart_rx
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/uart_rx_data
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/uart_rx_flag
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/uart_rx_r0
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/uart_rx_r1
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/uart_rx_r2
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/rx_flag
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/bit_flag
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/bit_cnt
add wave -noupdate /tb_top/u_uart_top/u_uart_rx/baud_cnt
