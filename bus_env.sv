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

    // Control properties
    protected int num_masters = 0;
    protected int num_slaves = 0;

    // The following two bits are used to control whether checks and coverage are
    // done both in the bus monitor class and the interface.
    bit intf_checks_enable = 1; 
    bit intf_coverage_enable = 1;
	
    bus_master_agent master_agent0;
    bus_slave_agent slave_agent0;

    // Provide implementations of virtual methods such as get_type_name and create
    `uvm_component_utils_begin(bus_env)
        `uvm_field_int(num_masters, UVM_DEFAULT)
        `uvm_field_int(num_slaves, UVM_DEFAULT)
        `uvm_field_int(intf_checks_enable, UVM_DEFAULT)
        `uvm_field_int(intf_coverage_enable, UVM_DEFAULT)
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
        
        master_agent0 = bus_master_agent::type_id::create(inst_name, this);
        
        slave_agent0 = bus_slave_agent::type_id::create(inst_name, this);

    endfunction : build_phase

    // update_vif_enables
    protected task update_vif_enables();
        forever begin
        @(intf_checks_enable || intf_coverage_enable);
        vif.has_checks <= intf_checks_enable;
        vif.has_coverage <= intf_coverage_enable;
        end
    endtask : update_vif_enables

    // implement run task
    task run_phase(uvm_phase phase);
        fork
        update_vif_enables();
        join
    endtask : run_phase

endclass : bus_env
