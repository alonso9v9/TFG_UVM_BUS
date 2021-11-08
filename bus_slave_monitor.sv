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

class bus_slave_monitor #(parameter pckg_sz=16,parameter drvrs=4,parameter fif_Size=10,parameter brodcst={8{1'b1}},parameter bits =1) extends uvm_monitor;


    protected virtual bus_if #(.pckg_sz(pckg_sz),.drvrs(drvrs),.bits(bits)) vif;
    int espera;
    bit [pckg_sz-1:0] D_in [bits-1:0][drvrs-1:0][$:fif_Size]; //FIFOS 
    bit checks_enable = 1;

    uvm_analysis_port#(bus_transfer) item_collected_port;

    protected bus_transfer transaction;
  	
  	
  	`uvm_component_utils_begin(bus_slave_monitor)
  		`uvm_field_int(espera, UVM_DEFAULT)
    	`uvm_field_int(checks_enable, UVM_DEFAULT)
  	`uvm_component_utils_end

  
 
    function new(string name, uvm_component parent=null);
        super.new(name, parent);
        transaction = new();
        item_collected_port = new("item_collected_port", this);
    endfunction : new


    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
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
        forever begin

            void'(this.begin_tr(transaction));


            $display("[%g] el monitor esta enviado el dato al scoreboard",$time);        
            espera = 0;
            @(posedge vif.clock);

            while(espera < transaction.retardo)begin
                @(posedge vif.clock);
                    espera = espera+1;
            end

            if (vif.D_push[0][0][pckg_sz-1:pckg_sz-8]==brodcst) begin
                transaction.tipo=broadcast;
                foreach(vif.push[0][i]) begin
                    if (vif.push[0][i]) begin
                        D_in[0][i].push_back(vif.D_push[0][i]);
                        transaction.dato=D_in[0][i].pop_front;
                    end
                end
                item_collected_port.write(transaction);
                $display("[MONITOR] [%g] Operación completada",$time);
                transaction.tiempo=$time;
                transaction.print("Monitor: Transaccion enviada al checker");
            end else
            begin
                foreach(vif.push[i,j]) begin
                automatic int a_i,a_j;
                a_i=i;
                a_j=j;
                fork
                    forever @(posedge vif.clock) begin              
                    if (vif.reset) begin
                        transaction.tipo=reset;
                      D_in[a_i][a_j].push_back(vif.D_push[a_i][a_j]);
                        $display("[MONITOR] [%g] Operación completada",$time);
                        transaction.tiempo=$time;
                      transaction.dato=D_in[a_i][a_j].pop_front;
                        item_collected_port.write(transaction);

                        `uvm_info(get_type_name(), $sformatf("Transfer collected :\n%s", transaction.sprint()), UVM_FULL)
                        
                        item_collected_port.write(transaction);
                    end else 
                    begin
                      if (vif.push[a_i][a_j]) begin
                            transaction.tipo=trans;
                        D_in[a_i][a_j].push_back(vif.D_push[a_i][a_j]);
                            $display("[MONITOR][%g] Operación completada",$time);
                            transaction.tiempo=$time;
                            transaction.dato=D_in[a_i][a_j].pop_front;
                            item_collected_port.write(transaction);

                            `uvm_info(get_type_name(), $sformatf("Transfer collected :\n%s", transaction.sprint()), UVM_FULL)
                        
                            item_collected_port.write(transaction);
                        end
                    end 
                    end
                join_none
                end
            end

        @(posedge vif.clock);
        end
    endtask : collect_transactions


    //constraint dest{dato[pckg_sz-1:pckg_sz-8]==Destino; Destino>=0;}

  
  	//Assertions


endclass : bus_slave_monitor