./salida -cm line+tgl+cond+fsm+branch+assert +ITER=200 +UVM_TIMEOUT=100000 > run_log
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="max_alter_test" +ITER=50 +UVM_TIMEOUT=1000000>run_log_alter 
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="dest_alter_test" +ITER=200 +UVM_TIMEOUT=100000>run_log_dest 
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="orig_alter_test" +ITER=200 +UVM_TIMEOUT=100000> run_log_orig 
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="bursts_test" +ITER=50 +BURSTS=10 +UVM_TIMEOUT=100000> run_log_burst
