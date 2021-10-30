// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Librería de tests para un bus paralelo parametrizable

`include "bus_tb.sv"

// Base Test
class bus_base_test extends uvm_test;

    `uvm_component_utils(bus_base_test)

    bus_tb bus_tb0;
    uvm_table_printer printer;
    bit test_pass = 1;

    function new(string name = "bus_base_test", 
        uvm_component parent=null);
        super.new(name,parent);
    endfunction : new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#(int)::set(this, "*", "recording_detail", UVM_FULL);
        // Create the tb
        bus_tb0 = bus_tb::type_id::create("bus_tb0", this);
        // Create a specific depth printer for printing the created topology
        printer = new();
        printer.knobs.depth = 3;
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
        $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
    endfunction : end_of_elaboration_phase

    //task run_phase(uvm_phase phase);
        //set a drain-time for the environment if desired
        //phase.phase_done.set_drain_time(this, 50);
    //endtask : run_phase

    function void extract_phase(uvm_phase phase);
        if(bus_tb0.scoreboard0.sbd_error)
        test_pass = 1'b0;
    endfunction // void

    function void report_phase(uvm_phase phase);
        if(test_pass) begin
        `uvm_info(get_type_name(), "** UVM TEST PASSED **", UVM_NONE)
        end
        else begin
        `uvm_error(get_type_name(), "** UVM TEST FAIL **")
        end
    endfunction

endclass : bus_base_test

class test_comun_case extends bus_base_test;

    `uvm_component_utils(test_comun_case)
  
    function new(string name = "test_comun_case", uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);

        //seq = random_sequence::type_id::create("seq");
        
        uvm_config_db#(uvm_object_wrapper)::set(this, "bus_tb0.bus0.master_agent0.sequencer.run_phase", "default_sequence", random_sequence::type_id::get());
        super.build_phase(phase);
        
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        //seq.start(bus_tb0.bus0.master_agent0.sequencer);
        phase.drop_objection(this);
        

        
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase
  
  endclass : test_comun_case 
  
class max_alter_test extends bus_base_test;

    `uvm_component_utils(max_alter_test)
  
    function new(string name = "max_alter_test", uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);

        //seq = random_sequence::type_id::create("seq");
        
        uvm_config_db#(uvm_object_wrapper)::set(this, "bus_tb0.bus0.master_agent0.sequencer.run_phase", "default_sequence", max_alter_seq::type_id::get());
        super.build_phase(phase);
        
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        //seq.start(bus_tb0.bus0.master_agent0.sequencer);
        phase.drop_objection(this);
        

        
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase
  
  endclass : max_alter_test 


class dest_alter_test extends bus_base_test;

    `uvm_component_utils(dest_alter_test)
  
    function new(string name = "dest_alter_test", uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);

        //seq = random_sequence::type_id::create("seq");
        
        uvm_config_db#(uvm_object_wrapper)::set(this, "bus_tb0.bus0.master_agent0.sequencer.run_phase", "default_sequence", dest_alter_seq::type_id::get());
        super.build_phase(phase);
        
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        //seq.start(bus_tb0.bus0.master_agent0.sequencer);
        phase.drop_objection(this);
        

        
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase
  
endclass : dest_alter_test 


class orig_alter_test extends bus_base_test;

    `uvm_component_utils(orig_alter_test)
  
    function new(string name = "orig_alter_test", uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);

        //seq = random_sequence::type_id::create("seq");
        
        uvm_config_db#(uvm_object_wrapper)::set(this, "bus_tb0.bus0.master_agent0.sequencer.run_phase", "default_sequence", orig_alter_seq::type_id::get());
        super.build_phase(phase);
        
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        //seq.start(bus_tb0.bus0.master_agent0.sequencer);
        phase.drop_objection(this);
        

        
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase
  
endclass : orig_alter_test 


class bursts_test extends bus_base_test;

    `uvm_component_utils(bursts_test)
  
    function new(string name = "bursts_test", uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);

        //seq = random_sequence::type_id::create("seq");
        
        uvm_config_db#(uvm_object_wrapper)::set(this, "bus_tb0.bus0.master_agent0.sequencer.run_phase", "default_sequence", bursts_seq::type_id::get());
        super.build_phase(phase);
        
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        //seq.start(bus_tb0.bus0.master_agent0.sequencer);
        phase.drop_objection(this);
        

        
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase
  
endclass : bursts_test 


class invalid_dest_test extends bus_base_test;

    `uvm_component_utils(invalid_dest_test)
  
    function new(string name = "invalid_dest_test", uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);

        //seq = random_sequence::type_id::create("seq");
        
        uvm_config_db#(uvm_object_wrapper)::set(this, "bus_tb0.bus0.master_agent0.sequencer.run_phase", "default_sequence", invalid_dest_seq::type_id::get());
        super.build_phase(phase);
        
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        //seq.start(bus_tb0.bus0.master_agent0.sequencer);
        phase.drop_objection(this);
        

        
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase
  
endclass : invalid_dest_test 


class same_dest_test extends bus_base_test;

    `uvm_component_utils(same_dest_test)
  
    function new(string name = "same_dest_test", uvm_component parent=null);
      super.new(name,parent);
    endfunction : new
  
    virtual function void build_phase(uvm_phase phase);

        //seq = random_sequence::type_id::create("seq");
        
        uvm_config_db#(uvm_object_wrapper)::set(this, "bus_tb0.bus0.master_agent0.sequencer.run_phase", "default_sequence", same_dest_seq::type_id::get());
        super.build_phase(phase);
        
    endfunction : build_phase
  
    task run_phase(uvm_phase phase);
      
        phase.raise_objection(this);
        //seq.start(bus_tb0.bus0.master_agent0.sequencer);
        phase.drop_objection(this);
        

        
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 50);
    endtask : run_phase
  
endclass : same_dest_test 