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

    protected int master_id;

    bus_master_driver driver;
    uvm_sequencer#(bus_transfer) sequencer;

    // Provide implementations of virtual methods such as get_type_name and create
    `uvm_component_utils_begin(bus_master_agent)
        `uvm_field_int(master_id, UVM_DEFAULT)
    `uvm_component_utils_end

    // new - constructor
    function new (string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // build_phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(get_is_active() == UVM_ACTIVE) begin
            sequencer = uvm_sequencer#(bus_transfer)::type_id::create("sequencer", this);
            driver = bus_master_driver::type_id::create("driver", this);
        end
    endfunction : build_phase

    // connect_phase
    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction : connect_phase

endclass : bus_master_agent