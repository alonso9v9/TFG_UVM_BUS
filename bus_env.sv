// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Módulo enviroment del testbench de un bus paralelo parametrizable

//------------------------------------------------------------------------------
//
// CLASS: bus_env
//
//------------------------------------------------------------------------------

class bus_env extends uvm_env;

    // Virtual Interface variable
    protected virtual interface bus_if vif;

	
    bus_master_agent master_agent0;
    bus_slave_agent slave_agent0;

    // Provide implementations of virtual methods such as get_type_name and create
    `uvm_component_utils_begin(bus_env)
    `uvm_component_utils_end

    // new - constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // build_phase
    function void build_phase(uvm_phase phase);
        string inst_name;
        super.build_phase(phase);
        if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
        
        master_agent0 = bus_master_agent::type_id::create("master_agent0", this);
        
        slave_agent0 = bus_slave_agent::type_id::create("slave_agent0", this);

    endfunction : build_phase

endclass : bus_env
