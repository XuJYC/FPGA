if [file exists work] {
    vdel -all
}

vlib work
vmap work work

# compiler all files
vlog "*.v"

# start simulation
vsim -gui -t ns -L altera_mf_ver -novopt work.tb_top

# add waves
do waves.do

run 1000
run 5ms

wave zoom full


