source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh
for bits in {16..32..2} 
	do
	for drvrs in 2 4 8 16 	
	do
		for seed in  {1..100}
		do
			echo -e "package bus_parameters;\nparameter bits=$bits;\nparameter drvrs=$drvrs;\n parameter fif_Size=1000;\nparameter buses=1;\nendpackage:bus_parameters" > bus_parameters.sv
			./comando.sh $seed
			if $?; then
				echo -e "\n\n\n\n\nError in run bits=$bits, drvrs=$drvrs"
				return 1
			fi
		done
	done
done
