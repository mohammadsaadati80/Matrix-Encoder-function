	alias clc ".main clear"
	
	clc
	exec vlib work
	vmap work work
	
	set TB					"testbench_3"
	set hdl_path			"../src/hdl"
	
	set run_time			"-all"

#============================ Add verilog files  ===============================
# Pleas add other module here	
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/permute/permutation_func.v
	vlog 	+acc -incr -source  +define+SIM		$hdl_path/permute/requirements.v
	vlog 	+acc -incr -source  +define+SIM 	$hdl_path/permute/controller.v
	vlog 	+acc -incr -source  +define+SIM		$hdl_path/permute/datapath.v
	vlog 	+acc -incr -source  +define+SIM		$hdl_path/permute/swap.v
	vlog 	+acc -incr -source  +define+SIM		$hdl_path/permute/read_from_file.v
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
	