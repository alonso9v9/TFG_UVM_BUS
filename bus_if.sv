// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Interface con el DUT del testbench de un bus paralelo parametrizable


interface bus_if #(parameter pckg_sz = 16, parameter drvrs = 4, parameter bits = 1);

  //Signals
	logic clock;
	logic reset;
	logic pndng[bits-1:0][drvrs-1:0];
	
	logic pop[bits-1:0][drvrs-1:0];
	logic [pckg_sz-1:0] D_pop [bits-1:0][drvrs-1:0];
	
	logic push[bits-1:0][drvrs-1:0];
	logic [pckg_sz-1:0] D_push [bits-1:0][drvrs-1:0];

    // clocking driver_cb @(posedge clock);
    //     default input #1 output #1;
    //     output D_push
    //     input pndng
    //     output push
    //     output pop 
    //     input D_pop
    // endclocking

    // clocking monitor_cb @(posedge clock);
    //     default input #1 output #1;
    //     input D_push
    //     input pndng
    //     input push
    //     input pop 
    //     input D_pop
    // endclocking

    // modport Driver (clocking driver_cb, input clk, reset);

    // modport Monitor (clocking monitor_cb, input clk, reset);


  // Coverage and assertions


//////////////ASSERTIONS//////////////
endinterface : bus_if
