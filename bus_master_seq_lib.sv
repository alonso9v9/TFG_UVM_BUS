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


/*
//------------------------------------------------------------------------------
//
// SEQUENCE: read_byte
//
//------------------------------------------------------------------------------
rand int retardo;
rand bit [pckg_sz-1:0] dato;
realtime tiempo;
rand tipo_acc tipo;
int max_retardo;
rand bit [7:0] Origen;
rand bit [7:0] Destino;

class read_byte_seq extends bus_base_sequence;

    function new(string name="read_byte_seq");
        super.new(name);
    endfunction

    `uvm_object_utils(read_byte_seq)

    rand bit [15:0] start_addr;
    rand int unsigned transmit_del = 0;
    constraint transmit_del_ct { (transmit_del <= 10); }

    virtual task body();
        `uvm_do_with(req, 
            req.addr == start_addr;
            req.read_write == READ;
            req.size == 1;
            req.error_pos == 1000;
            req.transmit_delay == transmit_del; } )
        get_response(rsp);
        `uvm_info(get_type_name(), $sformatf("%s read : addr = `x%0h, data[0] = `x%0h", get_sequence_path(), rsp.addr, rsp.data[0]), UVM_HIGH);
    endtask

endclass : read_byte_seq


//------------------------------------------------------------------------------
//
// SEQUENCE: read_half_word_seq
//
//------------------------------------------------------------------------------

class read_half_word_seq extends bus_base_sequence;

    function new(string name="read_half_word_seq");
        super.new(name);
    endfunction

    `uvm_object_utils(read_half_word_seq)

    rand bit [15:0] start_addr;
    rand int unsigned transmit_del = 0;
    constraint transmit_del_ct { (transmit_del <= 10); }

    virtual task body();
        `uvm_do_with(req, 
        { req.addr == start_addr;
            req.read_write == READ;
            req.size == 2;
            req.error_pos == 1000;
            req.transmit_delay == transmit_del; } )
        get_response(rsp);
        `uvm_info(get_type_name(),
        $sformatf("%s read : addr = `x%0h, data[0] = `x%0h, data[1] = `x%0h", get_sequence_path(), rsp.addr, rsp.data[0], rsp.data[1]), UVM_HIGH);
    endtask

endclass : read_half_word_seq */ 
