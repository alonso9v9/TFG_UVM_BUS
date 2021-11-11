source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh
for bits in {16..28..6} 
	do
	for drvrs in 2 4 8 16 	
	do
        echo -e "package bus_parameters;\nparameter bits=$bits;\nparameter drvrs=$drvrs;\nparameter fif_Size=1000;\nparameter buses=1;\nendpackage:bus_parameters" > bus_parameters.sv
        vcs -Mupdate testbench.sv  -o salida_${drvrs}_${bits}  -full64 -sverilog  -kdb -debug_acc+all -debug_region+cell+encrypt -l log_test -ntb_opts uvm-1.2 +lint=TFIPC-L -cm line+tgl+fsm+cond+branch+assert -cm_tgl assign+portsonly+fullintf+mda+count+structarr -lca
		for seed in  {1..50}
		do
            echo "Running seed $seed with bits $bits drvrs $drvrs"
            ./comando.sh $drvrs $bits $seed

		done
	done
done
