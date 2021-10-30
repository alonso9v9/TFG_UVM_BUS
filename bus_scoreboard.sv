// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Modulo Scoreboard del testbench de un bus paralelo parametrizable

//------------------------------------------------------------------------------
//
// CLASS: bus_scoreboard
//
//------------------------------------------------------------------------------

class bus_scoreboard extends uvm_scoreboard;
  
  
  uvm_analysis_imp#(bus_transfer, bus_scoreboard) gldnref_item_collected_export;
  uvm_analysis_imp#(bus_transfer, bus_scoreboard) monitor_item_collected_export;
  uvm_analysis_imp#(bus_transfer, bus_scoreboard) driver_item_collected_export;

    protected bit disable_scoreboard = 0;
    protected int num_writes = 0;
    protected int num_init_reads = 0;
    protected int num_uninit_reads = 0;
    int sbd_error = 0;

    protected int unsigned m_mem_expected[int unsigned];


    `uvm_component_utils_begin(bus_scoreboard)
        `uvm_field_int(disable_scoreboard, UVM_DEFAULT)
        `uvm_field_int(num_writes, UVM_DEFAULT|UVM_DEC)
        `uvm_field_int(num_init_reads, UVM_DEFAULT|UVM_DEC)
        `uvm_field_int(num_uninit_reads, UVM_DEFAULT|UVM_DEC)
    `uvm_component_utils_end


    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    //build_phase
    function void build_phase(uvm_phase phase);
        gldnref_item_collected_export = new("gldnref_item_collected_export", this);
        monitor_item_collected_export = new("monitor_item_collected_export", this);
        driver_item_collected_export = new("driver_item_collected_export", this);
    endfunction

    // write
    virtual function void write(bus_transfer trans);
        
    endfunction : write

    // verify
    protected function void transaction_verify(input bus_transfer trans);

    endfunction : transaction_verify

    // report_phase
    virtual function void report_phase(uvm_phase phase);

    endfunction : report_phase

endclass : bus_scoreboard
