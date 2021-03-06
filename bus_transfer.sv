// Curso: EL-5617 Trabajo final de graduación
// Tecnologico de Costa Rica (www.tec.ac.cr)
// Desarrollador:
// Alonso Vega-Badilla (alonso_v_@estudiantec.cr)
// Este script esta estructurado en System Verilog
// Proposito General:
// Módulo transferencia del testbench de un bus paralelo parametrizable


//------------------------------------------------------------------------------
//
// CLASS: bus_transfer
//
//------------------------------------------------------------------------------

typedef enum {trans,broadcast,reset} tipo_acc; 


class bus_transfer #(parameter bits=bus_parameters::bits,parameter drvrs=bus_parameters::drvrs,parameter fif_Size=bus_parameters::fif_Size, parameter buses=bus_parameters::buses,parameter broadcast = {8{1'b1}}) extends uvm_sequence_item;
	rand int retardo;
	rand bit [bits-1:0] dato;
    rand bit [bits-9:0] payload;
	realtime tiempo;
	rand tipo_acc tipo;
	int max_retardo;
	rand bit [7:0] Origen;
	rand bit [7:0] Destino;


    constraint const_payload{dato[bits-9:0] == payload;}
  	constraint const_retardo{retardo<=max_retardo; retardo>=0;}
  	constraint dest{dato[bits-1:bits-8]==Destino; Destino>=0;}
  	constraint dist_Dest {Destino dist{broadcast:=0,[0:drvrs*buses-1]:=100,[drvrs:100000]:=0};}
  	constraint org{Origen<drvrs*buses;Origen>=0;}
  	constraint org_dest{Origen!=Destino;Origen>=0;Destino>=0;}
  	constraint const_broadcast{tipo==broadcast->Destino==broadcast;}


  `uvm_object_utils_begin(bus_transfer)
        `uvm_field_int    (retardo,        UVM_DEFAULT)
        `uvm_field_int    (dato,           UVM_DEFAULT)
        `uvm_field_int    (payload,           UVM_DEFAULT)
        `uvm_field_real    (tiempo,         UVM_DEFAULT)  
        `uvm_field_enum   (tipo_acc, tipo, UVM_DEFAULT)
        `uvm_field_int    (max_retardo,    UVM_DEFAULT)
        `uvm_field_int    (Origen,         UVM_DEFAULT)
        `uvm_field_int    (Destino,        UVM_DEFAULT)
    `uvm_object_utils_end

  	function new(string name = "bus_transfer_inst");
		super.new(name);
	endfunction

	function void print (string tag = "");
		$display("[TRANSFER PRINT][%g] %s Tipo=%s Tiempo=%g Retardo=%g dato=0x%h payload=0x%h Origen=0x%h Destino=0x%h",$time,tag,this.tipo,this.tiempo,this.retardo,
			this.dato,this.payload,this.Origen,this.Destino);
	endfunction
endclass