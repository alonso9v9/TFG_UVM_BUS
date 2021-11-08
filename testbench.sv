// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Modulo top del testbench de un bus paralelo parametrizable



`include "bus_parameters.sv"
`include "bus_pkg.sv"
`include "Bus_Micro_lib.sv"
`include "bus_if.sv"


module bus_tb_top;

    import uvm_pkg::*;
    import bus_pkg::*;
    import bus_parameters::*;
    `include "test_lib.sv" 

    bus_if #(parameter buses = buses,parameter bits = bits,parameter drvrs = drvrs) vif(); // SystemVerilog Interface

    prll_bs_gnrtr_n_rbtr #(parameter buses = buses,parameter bits = bits,parameter drvrs = drvrs, parameter broadcast = {8{1'b1}}) dut(
      .clk(vif.clock),
      .reset(vif.reset),
      .pndng(vif.pndng),
      .pop(vif.pop),
      .D_pop(vif.D_pop),
      .push(vif.push),
      .D_push(vif.D_push)
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

    initial begin
        $fsdbDumpfile("debug.fsdb");
        $fsdbDumpvars(1,bus_tb_top.vif,"+all");
        $fsdbDumpvars(1,bus_tb_top.dut,"+all");
        //$fsdbDumpvars();
    end

    //Generate Clock
    always begin
        #5 vif.clock = ~vif.clock;
    end

    

endmodule