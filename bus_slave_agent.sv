// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Módulo agente slave del testbench de un bus paralelo parametrizable


//------------------------------------------------------------------------------
//
// CLASS: bus_slave_agent
//
//------------------------------------------------------------------------------

class bus_slave_agent extends uvm_agent;

    bus_slave_monitor monitor;
    GoldenReference gldnref;

    // Provide implementations of virtual methods such as get_type_name and create
    `uvm_component_utils_begin(bus_slave_agent)
    `uvm_component_utils_end

    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // build_phase
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = bus_slave_monitor::type_id::create("monitor", this);
        gldnref = GoldenReference::type_id::create("gldnref", this);
    endfunction : build_phase


endclass : bus_slave_agent