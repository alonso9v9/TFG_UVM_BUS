// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Paquete de componentes del bus paralelo parametrizable


package bus_pkg;

    import uvm_pkg::*;

    `include "uvm_macros.svh"

    typedef uvm_config_db#(virtual bus_if #(.buses(bus_parameters::buses), .bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs))) bus_vif_config;
    typedef virtual bus_if #(.buses(bus_parameters::buses), .bits(bus_parameters::bits),.drvrs(bus_parameters::drvrs)) bus_vif;

    `include "bus_transfer.sv"

    `include "bus_master_sequencer.sv"
    `include "bus_master_driver.sv"
    `include "bus_master_agent.sv"

    `include "GoldenReference.sv"
    `include "bus_slave_monitor.sv"
    `include "bus_slave_agent.sv"

    `include "bus_env.sv"

endpackage: bus_pkg
