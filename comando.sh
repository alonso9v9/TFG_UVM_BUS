./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +ITER=50 +UVM_TIMEOUT=10000 
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="max_alter_test" +ITER=15 +UVM_TIMEOUT=10000
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="dest_alter_test" +ITER=50 +UVM_TIMEOUT=10000
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="orig_alter_test" +ITER=50 +UVM_TIMEOUT=10000
./salida -cm line+tgl+cond+fsm+branch+assert -seed $1 +UVM_TESTNAME="bursts_test" +ITER=20 +BURSTS=10 +UVM_TIMEOUT=10000
