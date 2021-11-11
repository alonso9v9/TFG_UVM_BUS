
for bits in  40  
	do
	for test in 1 2 3 4 5 	
	do
		printf "parameter bits= %d;\n parameter" $pckg $test $fifo  >> parameters.sv
		vcs -Mupdate parameters.sv testbench.sv  -o salida_${test}  -full64 -sverilog  -kdb -debug_acc+all -debug_region+cell+encrypt -l log_test +lint=TFIPC-L -debug_acces+r -cm tgl+cond+assert 
		./salida_${test} -cm tgl+cond+assert
		if $?; then
			printf "\n\n\n\n\nError in run pckg_sz=%d, test=%d, fifo_depth=%d\n\n\n\n" $pckg $test $fifo
			return 1
		fi
		
	done
done

#verdi -cov -covdir salida.vdb&
