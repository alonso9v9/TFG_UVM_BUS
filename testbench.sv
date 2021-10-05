// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Modulo top del testbench de un bus paralelo parametrizable


`define BUS_ADDR_WIDTH 16

`include "bus_pkg.sv"
`include "Library.sv"
`include "bus_if.sv"


module bus_tb_top;

    import uvm_pkg::*;
    import bus_pkg::*;
    `include "test_lib.sv" 

    bus_if vif(); // SystemVerilog Interface

    bs_gnrtr_n_rbtr dut(
      
      vif.clock,
      vif.reset,
      vif.pndng,
      vif.pop,
      vif.D_pop,
      vif.push,
      vif.D_push

    );

    initial begin
        uvm_config_db#(virtual bus_if)::set(uvm_root::get(), "*", "vif", vif);
        run_test("test_comun_case");
      	
    end

    initial begin
        vif.clock <= 1'b1;
        vif.reset <= 1'b0;
        #10
        vif.reset <= 1'b1;
        #41 vif.reset = 1'b0;
    end

    //Generate Clock
    always begin
        #5 vif.clock = ~vif.clock;
    end

endmodule