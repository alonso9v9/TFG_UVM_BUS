// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Modulo Agente Master del testbench de un bus paralelo parametrizable

//------------------------------------------------------------------------------
//
// CLASS: bus_master_agent
//
//------------------------------------------------------------------------------

class bus_master_agent extends uvm_agent;

    bus_master_driver #(.buses(bus_parameters::buses),.bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs),.broadcast({8{1'b1}})) driver;
    bus_master_sequencer sequencer;

    `uvm_component_utils_begin(bus_master_agent)
    `uvm_component_utils_end

    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = bus_master_sequencer::type_id::create("sequencer", this);
        driver = bus_master_driver#(.buses(bus_parameters::buses),.bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs),.broadcast({8{1'b1}}))::type_id::create("driver", this);
    endfunction : build_phase

    // connect_phase
    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

endclass : bus_master_agent