// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Interface con el DUT del testbench de un bus paralelo parametrizable


interface bus_if #(parameter pckg_sz = 16, parameter drvrs = 4, parameter bits = 1);

  //Flags
  bit                has_checks = 1;
  bit                has_coverage = 1;
  
  //Signals
	logic clock;
	logic reset;
	logic pndng[bits-1:0][drvrs-1:0];
	
	logic pop[bits-1:0][drvrs-1:0];
	logic [pckg_sz-1:0] D_pop [bits-1:0][drvrs-1:0];
	
	logic push[bits-1:0][drvrs-1:0];
	logic [pckg_sz-1:0] D_push [bits-1:0][drvrs-1:0];


  // Coverage and assertions

  always @(negedge clock)
  begin
    
  end

//////////////ASSERTIONS//////////////
endinterface : bus_if
