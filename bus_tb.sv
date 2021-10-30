// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Modulo testbench de un bus paralelo parametrizable

`include "bus_scoreboard.sv"
`include "bus_master_seq_lib.sv"

//------------------------------------------------------------------------------
//
// CLASS: bus_tb
//
//------------------------------------------------------------------------------

class bus_tb extends uvm_env;

    `uvm_component_utils(bus_tb)

    // bus environment
    bus_env bus0;

    // Scoreboard to check the memory operation of the slave.
    bus_scoreboard scoreboard0;

    // new
    function new (string name, uvm_component parent=null);

        super.new(name, parent);

    endfunction : new

    // build_phase
    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        bus0 = bus_env::type_id::create("bus0", this);
        scoreboard0 = bus_scoreboard::type_id::create("scoreboard0", this);

    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        
        bus0.slave_agent0.gldnref.item_collected_port.connect(scoreboard0.gldnref_item_collected_export);
      
        bus0.slave_agent0.monitor.item_collected_port.connect(scoreboard0.monitor_item_collected_export);
      
        bus0.master_agent0.driver.item_collected_port.connect(scoreboard0.driver_item_collected_export);
      
    endfunction : connect_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        
    endfunction : end_of_elaboration_phase

endclass : bus_tb