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


class bus_transfer #(parameter pckg_sz =16,parameter drvrs=4,parameter broadcast={8{1'b1}}, parameter bits = 1) extends uvm_sequence_item;
	rand int retardo;
	rand bit [pckg_sz-1:0] dato;
	realtime tiempo;
	rand tipo_acc tipo;
	int max_retardo;
	rand bit [7:0] Origen;
	rand bit [7:0] Destino;

  	constraint const_retardo{retardo<=max_retardo; retardo>=0;}
  	constraint dest{dato[pckg_sz-1:pckg_sz-8]==Destino; Destino>=0;}
  	constraint dist_Dest {Destino dist{broadcast:=0,[0:drvrs*bits-1]:=100,[drvrs:100000]:=0};}
  	constraint org{Origen<drvrs*bits;Origen>=0;}
  	constraint org_dest{Origen!=Destino;Origen>=0;Destino>=0;}
  	constraint const_broadcast{tipo==broadcast->Destino==broadcast;}


  `uvm_object_utils_begin(bus_transfer)
        `uvm_field_int    (retardo,        UVM_DEFAULT)
        `uvm_field_int    (dato,           UVM_DEFAULT)
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
		$display("[TRANSFER PRINT][%g] %s Tipo=%s Tiempo=%g Retardo=%g dato=0x%h Origen=0x%h Destino=0x%h",$time,tag,this.tipo,this.tiempo,this.retardo,
			this.dato,this.Origen,this.Destino);
	endfunction
endclass