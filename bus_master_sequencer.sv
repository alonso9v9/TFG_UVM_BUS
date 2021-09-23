// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Módulo sequencer master del testbench de un bus paralelo parametrizable


//------------------------------------------------------------------------------
//
// CLASS: bus_master_sequencer
//
//------------------------------------------------------------------------------

class bus_master_sequencer extends uvm_sequencer #(bus_transfer);

    `uvm_component_utils(bus_master_sequencer)
        
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

endclass : bus_master_sequencer