	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"testbench_5"
	set hdl_path			"../src/hdl"
	
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/addRC/addRC_Top.v
	vlog 	+acc -incr -source  +define+SIM		$hdl_path/addRC/requirements.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/addRC/controller.v
	vlog 	+acc -incr -source  +define+SIM		$hdl_path/addRC/datapath.v
	vlog 	+acc -incr -source  +define+SIM		$hdl_path/addRC/addRC.v
	vlog 	+acc -incr -source  +define+SIM 	./tb/$TB.v
		
#	onerror {break}

#================================ simulation ====================================

	vsim	-voptargs=+acc -debugDB $TB


#======================= adding signals to wave window ==========================


	add wave -hex -group 	 	{TB}				sim:/$TB/*
	add wave -hex -group 	 	{top}				sim:/$TB/uut/*	
	add wave -hex -group -r		{all}				sim:/$TB/*

#=========================== Configure wave signals =============================
	
	configure wave -signalnamewidth 2
    

#====================================== run =====================================

	run $run_time 
	