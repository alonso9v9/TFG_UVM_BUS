// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Modulo Driver Master del testbench de un bus paralelo parametrizable

//------------------------------------------------------------------------------
//
// CLASS: bus_master_driver
//
//------------------------------------------------------------------------------

class bus_master_driver #(parameter bits=bus_parameters::bits,parameter drvrs=bus_parameters::drvrs,parameter fif_Size=bus_parameters::fif_Size, parameter buses=bus_parameters::buses,parameter broadcast = {8{1'b1}}) extends uvm_driver #(bus_transfer);

	bit [bits-1:0] D_out [buses-1:0][drvrs-1:0][$:fif_Size]; //FIFOS
	int disp;
	int i;
	int j;
	realtime espera;

	
	// The virtual interface used to drive and view HDL signals.
	protected virtual bus_if #(.buses(bus_parameters::buses), .bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs)) vif;


    uvm_analysis_port #(bus_transfer) item_collected_port;

 
    protected bus_transfer transaction;


	`uvm_component_utils_begin(bus_master_driver)
	`uvm_component_utils_end

	// new - constructor
	function new (string name, uvm_component parent);

		super.new(name, parent);
		transaction = new();
		item_collected_port = new("item_collected_port", this);

	endfunction : new

	function void build_phase(uvm_phase phase);

		super.build_phase(phase);

		if(!uvm_config_db#(virtual bus_if #(.buses(bus_parameters::buses), .bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs)))::get(this, "", "vif", vif))
			`uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});

	endfunction: build_phase

	// run phase
	virtual task run_phase(uvm_phase phase);
		fork
            pndng_driver();
			get_and_drive();
			reset_signals();
		join
	endtask : run_phase

  
	// get_and_drive 
	virtual protected task get_and_drive();
      $display("[DRIVER] Get and drive initialized");
		@(negedge vif.reset);
		forever begin
			@(posedge vif.clock);
            $display("[DRIVER] Getting new item");
			seq_item_port.get_next_item(req);
			drive_transfer(req);
			seq_item_port.item_done();
		end

	endtask : get_and_drive

	// reset_signals
	virtual protected task reset_signals();
		forever begin
			@(posedge vif.reset);
			foreach(vif.D_pop[i]) begin
				foreach (vif.D_pop[i][j])begin
					vif.pndng[i][j] <= 'b0;
					vif.D_pop[i][j] <= 'h0;
				end
			end
		end
	endtask : reset_signals


	// 
    virtual protected task pndng_driver();
        foreach(D_out[i,j]) begin
            automatic int a_i, a_j;
            a_i=i;
            a_j=j;
        fork
            forever @(posedge vif.clock) begin
                vif.D_pop[a_i][a_j]<=D_out[a_i][a_j][0];
                //$display("Dato listo %h",vif.D_pop[a_i][a_j]);
            end
            forever @(posedge vif.pop[a_i][a_j]) begin
                    D_out[a_i][a_j].pop_front;
                    //$display ("POP at %h , %h", a_i,a_j);
                    //$display ("AFter POP %p", D_out[a_i][a_j]);
                    //$display ("SIZE %d",D_out[a_i][a_j].size());
                    if(D_out[a_i][a_j].size()==0)      
                        vif.pndng[a_i][a_j]<=0;
            end
            join_none
        end
    endtask
    
    
    // drive_transfer
  	virtual protected task drive_transfer (bus_transfer transaction);
		
		
		//$display("[DRIVER] [%g] El driver fue inicializado",$time);
		if (transaction.retardo > 0) begin
			repeat(transaction.retardo) @(posedge vif.clock);
		end

		@(posedge vif.clock);

        vif.reset=0;

        `uvm_info(get_full_name(), $sformatf("Transfer collected :\n%s", transaction.sprint()), UVM_MEDIUM)
        
        case(transaction.tipo)
            broadcast:begin
                foreach (D_out[a_i]) begin
                    foreach (D_out[a_i][a_j]) begin
                        disp=i*drvrs+j; //CAMBIAR para ser generico
                        if (disp!=transaction.Origen) begin
                        D_out[a_i][a_j].push_back(transaction.dato);
                            vif.pndng[a_i][a_j]<=1;
                        end 
                    end
                end
                //transaction.print("Driver: Transaccion ejecutada");
            end

            trans:begin

                if (transaction.Origen>=drvrs) begin
                    i=1;
                    j=transaction.Origen-drvrs;
                end else begin
                    i=0;
                    j=transaction.Origen;
                end
                
                D_out[i][j].push_back(transaction.dato); //Agregamos el dato enviado en la fifo out del origen
                vif.pndng[i][j]<=1;
                vif.D_pop[i][j]<=D_out[i][j][0];
                transaction.tiempo = $realtime;
                //transaction.print("Driver: Transaccion ejecutada");
            end

            reset:begin
                reset_signals();
                transaction.tiempo = $time;
                //transaction.print("Driver: Transaccion ejecutada");
            end

            default:begin
                $display("[DRIVER] [%g] Driver Error: la transacción recibida no tiene tipo valido",$time);
                $finish;
            end
        endcase // trans.tipo
        item_collected_port.write(transaction);
        @(posedge vif.clock);

	endtask : drive_transfer


endclass : bus_master_driver