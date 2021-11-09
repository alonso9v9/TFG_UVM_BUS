// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Modulo Scoreboard del testbench de un bus paralelo parametrizable

//------------------------------------------------------------------------------
//
// CLASS: bus_scoreboard
//
//------------------------------------------------------------------------------
`uvm_analysis_imp_decl(_gldnref_export)
`uvm_analysis_imp_decl(_monitor_export)
`uvm_analysis_imp_decl(_driver_export)
class bus_scoreboard extends uvm_scoreboard;
  
  
    uvm_analysis_imp_gldnref_export#(bus_transfer, bus_scoreboard) gldnref_export;
    uvm_analysis_imp_monitor_export#(bus_transfer, bus_scoreboard) monitor_export;
    uvm_analysis_imp_driver_export#(bus_transfer, bus_scoreboard) driver_export;

    bus_transfer gldnref_list[$];
    bus_transfer monitor_list[$];
    bus_transfer driver_list[$];
    bus_transfer pndng_list[$];

    protected bit disable_scoreboard = 0;
    protected int num_writes = 0;
    protected int num_init_reads = 0;
    protected int num_uninit_reads = 0;
    int sbd_error = 0;
    int found =0;

    protected int unsigned m_mem_expected[int unsigned];


    `uvm_component_utils_begin(bus_scoreboard)
        `uvm_field_int(disable_scoreboard, UVM_DEFAULT)
        `uvm_field_int(num_writes, UVM_DEFAULT|UVM_DEC)
        `uvm_field_int(num_init_reads, UVM_DEFAULT|UVM_DEC)
        `uvm_field_int(num_uninit_reads, UVM_DEFAULT|UVM_DEC)
    `uvm_component_utils_end


    function new (string name, uvm_component parent);
        super.new(name, parent);
        gldnref_export = new("gldnref_export", this);
        monitor_export = new("monitor_export", this);
        driver_export = new("driver_export", this);
    endfunction : new

    //build_phase
    function void build_phase(uvm_phase phase);

    endfunction

    // write_gldnref
    function void write_gldnref_export(bus_transfer t);
        gldnref_list.push_back(t);
        t.print ("GLDNREF");
    endfunction

    function void write_monitor_export(bus_transfer t);
        monitor_list.push_back(t);
        t.print ("MONITOR");
        //Search in Driver list to see if this was sent
        this.found=0;
        foreach (pndng_list[i]) begin
            if (pndng_list[i].dato==t.dato && pndng_list[i].Destino == t.Destino) begin
                this.found=1;
                pndng_list.delete(i);
                $display("[FOUND] t.dato %h,t.Destino %h", t.dato, t.Destino);
                foreach (pndng_list[i]) begin
                    $display ("PENDING DATA AFTER FOUND %h", pndng_list[i].dato );
                end
                break;                
            end
        end
        if (this.found==0) begin
            $display("[NOT FOUND] t.dato %h,t.Destino %h", t.dato, t.Destino);
            sbd_error=1;
        end
    endfunction

    function void write_driver_export(bus_transfer t);
        driver_list.push_back(t);
        pndng_list.push_back(t);
        t.print ("DRIVER");
    endfunction

    // verify
    protected function void transaction_verify(input bus_transfer trans);

    endfunction : transaction_verify

    // report_phase
    virtual function void report_phase(uvm_phase phase);

    endfunction : report_phase

endclass : bus_scoreboard
