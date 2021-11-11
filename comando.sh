source /mnt/vol_NFS_rh003/estudiantes/archivos_config/synopsys_tools.sh
vcs -Mupdate testbench.sv  -o salida  -full64 -sverilog  -kdb -debug_acc+all -debug_region+cell+encrypt -l log_test -ntb_opts uvm-1.2 +lint=TFIPC-L -cm line+tgl+cond+fsm+branch+assert -cm_tgl assign+portsonly+fullintf+mda+count+structarr -lca
./salida -cm line+tgl+cond+fsm+branch+assert +ITER=500 +UVM_TIMEOUT=100000 > run_log
./salida -cm line+tgl+cond+fsm+branch+assert +UVM_TESTNAME="max_alter_test" +ITER=500 +UVM_TIMEOUT=100000>run_log_alter 
./salida -cm line+tgl+cond+fsm+branch+assert +UVM_TESTNAME="dest_alter_test" +ITER=500 +UVM_TIMEOUT=100000>run_log_dest 
./salida -cm line+tgl+cond+fsm+branch+assert +UVM_TESTNAME="orig_alter_test" +ITER=500 +UVM_TIMEOUT=100000> run_log_orig 
./salida -cm line+tgl+cond+fsm+branch+assert +UVM_TESTNAME="bursts_test" +ITER=30 +BURSTS=10 +UVM_TIMEOUT=100000> run_log_burst
