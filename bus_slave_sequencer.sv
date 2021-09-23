// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Módulo sequencer slave del testbench de un bus paralelo parametrizable



//------------------------------------------------------------------------------
//
// CLASS: bus_slave_sequencer
//
//------------------------------------------------------------------------------

class bus_slave_sequencer extends uvm_sequencer #(bus_transfer);

    // TLM port to peek the address phase from the slave monitor
    uvm_blocking_peek_port#(bus_transfer) addr_ph_port;

    // Provide implementations of virtual methods such as get_type_name and create
    `uvm_component_utils(bus_slave_sequencer)


    function new (string name, uvm_component parent);
        super.new(name, parent);
        addr_ph_port = new("addr_ph_port", this);
    endfunction : new

endclass : bus_slave_sequencer