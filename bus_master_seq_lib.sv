// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Librería de secuencias para el testbench de un bus paralelo parametrizable

//------------------------------------------------------------------------------
//
// SEQUENCE: bus_base_sequence
//
//------------------------------------------------------------------------------

// This sequence raises/drops objections in the pre/post_body so that root
// sequences raise objections but subsequences do not.

virtual class bus_base_sequence extends uvm_sequence #(bus_transfer);

    function new(string name="bus_base_seq");
        super.new(name);
    endfunction
    
    // Raise in pre_body so the objection is only raised for root sequences.
    // There is no need to raise for sub-sequences since the root sequence
    // will encapsulate the sub-sequence. 
    virtual task pre_body();
        if (starting_phase!=null) begin
            `uvm_info(get_type_name(), $sformatf("%s pre_body() raising %s objection", get_sequence_path(), starting_phase.get_name()), UVM_MEDIUM);
            starting_phase.raise_objection(this);
        end
    endtask

    // Drop the objection in the post_body so the objection is removed when
    // the root sequence is complete. 
    virtual task post_body();
        if (starting_phase!=null) begin
            `uvm_info(get_type_name(), $sformatf("%s post_body() dropping %s objection", get_sequence_path(), starting_phase.get_name()), UVM_MEDIUM);
            starting_phase.drop_objection(this);
        end
    endtask

endclass

class random_sequence extends bus_base_sequence;

    `uvm_object_utils(random_sequence)
    
    function new(string name="random_sequence");
      super.new(name);
    endfunction
    
    
  
    rand int retardo;
    int iter;

    constraint retardo_ct { (retardo <= 10); }

  
    virtual task body();
        $display("SEQUENCE BODY");
        if ($value$plusargs("ITER=%d",iter))
            repeat (iter) begin
                `uvm_do_with(req, 
                { req.tipo == trans;
                req.retardo == retardo;} )
                $display("[SEQUENCE] Item sent to driver");
                `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
            end 
        else begin
            $display("NO ITER NUMBER");
        end 

    endtask
    
  endclass : random_sequence

  class max_alter_seq extends bus_base_sequence;

    `uvm_object_utils(max_alter_seq)
    
    function new(string name="max_alter_seq");
      super.new(name);
    endfunction
    
    rand int retardo;
    int iter;

    constraint retardo_ct { (retardo <= 10); }

  
    virtual task body();
        $display("SEQUENCE BODY");
        
        if ($value$plusargs("ITER=%d",iter))
            repeat (iter) begin
                `uvm_do_with(req, 
                { req.tipo == trans;
                req.retardo == retardo;
                req.payload == 'h000000000000;} )
                $display("[SEQUENCE] Item sent to driver");
                `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);

                `uvm_do_with(req, 
                { req.tipo == trans;
                req.retardo == retardo;
                req.payload == 'hFFFFFFFFFFFF;} )
                $display("[SEQUENCE] Item sent to driver");
                `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);

                `uvm_do_with(req, 
                { req.tipo == trans;
                req.retardo == retardo;
                req.payload == 'hAAAAAAAAAAAAA;} )
                $display("[SEQUENCE] Item sent to driver");
                `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);

                `uvm_do_with(req, 
                { req.tipo == trans;
                req.retardo == retardo;
                req.payload == 'h5555555555555;} )
                $display("[SEQUENCE] Item sent to driver");
                `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
            end 
        else begin
            $display("NO ITER NUMBER");
        end
    endtask
    
  endclass : max_alter_seq


  class dest_alter_seq extends bus_base_sequence;

    `uvm_object_utils(random_sequence)
    
    function new(string name="random_sequence");
      super.new(name);
    endfunction
    
    
  
    rand int retardo;
    int iter;

    constraint retardo_ct { (retardo <= 10); }

  
    virtual task body();
        $display("SEQUENCE BODY");
        if ($value$plusargs("ITER=%d",iter))
            repeat (iter) begin

                for (int i=0; i<bus_parameters::drvrs; ++i) begin
                    `uvm_do_with(req, 
                    { req.tipo == trans;
                    req.retardo == retardo;
                    req.Destino == i;} )
                    $display("[SEQUENCE] Item sent to driver");
                    `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
                end

            end 
        else begin
            $display("NO ITER NUMBER");
        end 

    endtask
    
  endclass : dest_alter_seq



  class orig_alter_seq extends bus_base_sequence;

    `uvm_object_utils(random_sequence)
    
    function new(string name="random_sequence");
      super.new(name);
    endfunction
    
    
  
    rand int retardo;
    int iter;

    constraint retardo_ct { (retardo <= 10); }

  
    virtual task body();
        $display("SEQUENCE BODY");
        if ($value$plusargs("ITER=%d",iter))
            repeat (iter) begin
                for (int i=0; i<bus_parameters::drvrs; ++i) begin
                    `uvm_do_with(req, 
                    { req.tipo == trans;
                    req.retardo == retardo;
                    req.Origen == i;} )
                    $display("[SEQUENCE] Item sent to driver");
                    `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
                end
            end 
        else begin
            $display("NO ITER NUMBER");
        end 

    endtask
    
  endclass : orig_alter_seq



  class bursts_seq extends bus_base_sequence;

    `uvm_object_utils(random_sequence)
    
    function new(string name="random_sequence");
      super.new(name);
    endfunction
    
    
  
    rand int retardo;
    int iter;
    int burst;

    constraint retardo_ct { (retardo <= 10); }

  
    virtual task body();
        $display("SEQUENCE BODY");
        if ($value$plusargs("ITER=%d",iter)) begin 
            repeat (iter) begin
                if ($value$plusargs("BURSTS=%d",burst))begin
                    repeat (burst/2) begin 
                        `uvm_do_with(req, 
                        { req.tipo == trans;
                        req.retardo == retardo;} )
                        $display("[SEQUENCE] Item sent to driver");
                        `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
                    end
                    repeat (burst) begin
                        #1;
                    end
                    repeat (burst/2) begin 
                        `uvm_do_with(req, 
                        { req.tipo == trans;
                        req.retardo == retardo;} )
                        $display("[SEQUENCE] Item sent to driver");
                        `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
                    end
                end
            end
        end else begin
            $display("NO ITER NUMBER");
        end 

    endtask
    
  endclass : bursts_seq

  class invalid_dest_seq extends bus_base_sequence;

    `uvm_object_utils(random_sequence)
    
    function new(string name="random_sequence");
      super.new(name);
    endfunction
    
    
  
    rand int retardo;
    int iter;

    constraint retardo_ct { (retardo <= 10); }

  
    virtual task body();
        $display("SEQUENCE BODY");
        if ($value$plusargs("ITER=%d",iter))
            repeat (iter) begin
                `uvm_do_with(req, 
                { req.tipo == trans;
                req.retardo == retardo;} )
                $display("[SEQUENCE] Item sent to driver");
                `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
            end 
        else begin
            $display("NO ITER NUMBER");
        end 

    endtask
    
  endclass : invalid_dest_seq


  class same_dest_seq extends bus_base_sequence;

    `uvm_object_utils(random_sequence)
    
    function new(string name="random_sequence");
      super.new(name);
    endfunction
    
    
  
    rand int retardo;
    int iter;

    constraint retardo_ct { (retardo <= 10); }

  
    virtual task body();
        $display("SEQUENCE BODY");
        if ($value$plusargs("ITER=%d",iter))
            repeat (iter) begin
                `uvm_do_with(req, 
                { req.tipo == trans;
                req.retardo == retardo;} )
                $display("[SEQUENCE] Item sent to driver");
                `uvm_info(get_type_name(), $sformatf("SEQUENCE item sent"), UVM_HIGH);
            end 
        else begin
            $display("NO ITER NUMBER");
        end 

    endtask
    
  endclass : same_dest_seq