// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Módulo monitor slave del testbench de un bus paralelo parametrizable


//------------------------------------------------------------------------------
//
// CLASS: bus_slave_monitor
//
//------------------------------------------------------------------------------

class bus_slave_monitor #(parameter bits=bus_parameters::bits,parameter drvrs=bus_parameters::drvrs,parameter fif_Size=bus_parameters::fif_Size, parameter buses=bus_parameters::buses,parameter broadcast = {8{1'b1}}) extends uvm_monitor;


    protected virtual bus_if #(.buses(bus_parameters::buses), .bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs)) vif;
    bit [bits-1:0] D_in [buses-1:0][drvrs-1:0][$]; //FIFOS 
    bit checks_enable = 1;

    uvm_analysis_port#(bus_transfer) item_collected_port;

    protected bus_transfer transaction;
  	
  	
  	`uvm_component_utils_begin(bus_slave_monitor)
    	`uvm_field_int(checks_enable, UVM_DEFAULT)
  	`uvm_component_utils_end

  
 
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
        transaction = new();
        item_collected_port = new("item_collected_port", this);
    endfunction : new


    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual bus_if #(.buses(bus_parameters::buses), .bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs)))::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase


    // run phase
    virtual task run_phase(uvm_phase phase);
        fork
            collect_transactions();
        join
    endtask : run_phase


    virtual protected task collect_transactions();
            
        $display("[%g] El monitor fue inicializado",$time);
     

        @(posedge vif.clock);

        foreach(vif.push[i,j]) begin
            automatic int a_i,a_j;
            a_i=i;
            a_j=j;
            fork
                // forever @(posedge vif.reset) begin              
                //     transaction.tipo=reset;
                //     D_in[a_i][a_j].push_back(vif.D_push[a_i][a_j]);
                //     $display("[MONITOR] [%g] Operación completada RESET",$time);
                //     transaction.tiempo=$time;
                //     transaction.dato=D_in[a_i][a_j].pop_front;
                //     item_collected_port.write(transaction);

                //     `uvm_info(get_type_name(), $sformatf("Transfer collected :\n%s", transaction.sprint()), UVM_FULL)
                    
                //     item_collected_port.write(transaction);
                // end
                forever @(posedge vif.clock) begin 
                    if (~vif.reset & vif.push[a_i][a_j])begin
                        void'(this.begin_tr(transaction));
                        //$display("Push value %h at %h,%h",vif.push[a_i][a_j],a_i,a_j);
                        transaction.tipo=trans;
                        D_in[a_i][a_j].push_back(vif.D_push[a_i][a_j]);
                        $display("[MONITOR][%g] Operación completada",$time);
                        transaction.tiempo=$time;
                        transaction.dato=D_in[a_i][a_j].pop_front;
                        transaction.Destino=a_i*drvrs+a_j;
                        item_collected_port.write(transaction);

                        `uvm_info(get_type_name(), $sformatf("Transfer collected :\n%s", transaction.sprint()), UVM_FULL)
                    
                        //item_collected_port.write(transaction);
                    end 
                end
            join_none
        end
    endtask : collect_transactions


    //constraint dest{dato[bits-1:bits-8]==Destino; Destino>=0;}

  
  	//Assertions


endclass : bus_slave_monitor