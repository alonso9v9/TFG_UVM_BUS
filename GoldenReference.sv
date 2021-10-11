



class GoldenReference #(parameter pckg_sz=16,parameter drvrs=4,parameter fif_Size=10,parameter brodcst={8{1'b1}},parameter bits =1) extends uvm_monitor;

    bit [pckg_sz-1:0] Reg [bits-1:0][drvrs-1:0][$]; //FIFOS de salida
    
    protected virtual bus_if #(.pckg_sz(pckg_sz),.drvrs(drvrs),.bits(bits)) vif;

    semaphore turn [bits-1:0][drvrs-1:0];
    bit busy;
    bit [7:0] Destino;
    int dest_j, dest_i;
    protected bus_transfer transaction;

    uvm_analysis_port #(bus_transfer) item_collected_port;

    `uvm_component_utils_begin(GoldenReference)
    `uvm_component_utils_end



    function new(string name, uvm_component parent=null);
        super.new(name, parent);
        turn = new(0);
        busy=0;

        transaction = new();
        item_collected_port = new("item_collected_port", this);
    endfunction : new


    function void build_phase(uvm_phase phase);
        if(!uvm_config_db#(virtual bus_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF",{"virtual interface must be set for: ",get_full_name(),".vif"});
    endfunction: build_phase


    virtual task run_phase(uvm_phase phase);
		fork
            arbiter();
			get_transaction();
		join
	endtask : run_phase


    virtual protected task arbiter ();
        forever @(vif.pndng) begin
            if (!busy) begin
                if (vif.pndng != 0) begin
                    for (int i=0; i<bits; ++i) begin
                        for (int j=0; j<drvrs; ++j) begin
                            if (vif.pndng[i][j]) begin
                                turn[i][j].put(1);
                                busy=1;
                                break;
                            end
                        end
                        if (busy) begin
                            break;
                        end
                    end
                end
            end
        end
    endtask 
    
    virtual protected task get_transaction();
        
        foreach(vif.pndng[i,j]) begin
            automatic int a_i, a_j;
            a_i=i;
            a_j=j;
            fork
                forever @(posedge vif.clock) begin
                    if (vif.pndng[a_i][a_j]) begin
                        
                        turn[i][j].get(1);
                        
                        //Mandar dato a destino
                        Destino = vif.D_pop[i][j][pckg_sz-1:pckg_sz-8];

                        dest_i=Destino/drvrs;
                        dest_j=Destino%drvrs;
                        Reg[dest_i][dest_j].push_back(vif.D_pop[i][j]);

                        //enviar dato recibido a scoreboard 
                        transaction.dato=vif.D_pop[i][j];
                        item_collected_port.write(transaction);
                        busy=0;
                    end
                end
            join_none
        end

    endtask
    
endclass