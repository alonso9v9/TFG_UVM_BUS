./salida_${1}_${2} -cm line+tgl+cond+fsm+branch+assert +ntb_random_seed $3 +ITER=50 +UVM_TIMEOUT=10000 +UVM_VERBOSITY=UVM_HIGH> run_log
./salida_${1}_${2} -cm line+tgl+cond+fsm+branch+assert +ntb_random_seed $3 +UVM_TESTNAME="max_alter_test" +ITER=15 +UVM_TIMEOUT=10000 +UVM_VERBOSITY=UVM_HIGH> run_log_alter
./salida_${1}_${2} -cm line+tgl+cond+fsm+branch+assert +ntb_random_seed $3 +UVM_TESTNAME="dest_alter_test" +ITER=50 +UVM_TIMEOUT=10000 +UVM_VERBOSITY=UVM_HIGH> run_log_dest
./salida_${1}_${2} -cm line+tgl+cond+fsm+branch+assert +ntb_random_seed $3 +UVM_TESTNAME="orig_alter_test" +ITER=50 +UVM_TIMEOUT=10000 +UVM_VERBOSITY=UVM_HIGH> run_log_orig
./salida_${1}_${2} -cm line+tgl+cond+fsm+branch+assert +ntb_random_seed $3 +UVM_TESTNAME="bursts_test" +ITER=20 +BURSTS=10 +UVM_TIMEOUT=10000 +UVM_VERBOSITY=UVM_HIGH> run_log_burst
