`ifndef FIFOS
   `include "../FIFO_Latches/fifo.sv"
    `define FIFOS
`endif

//`ifndef LIB
//   `include "../BUS/Library.sv"
//    `define LIB
//`endif


module tri_buf (a,b,en);
    input a;
    output b;
    input en;
    wire a,en;
    wire b;
    
   assign b = (en) ? a : 1'bz;
     	  	 
endmodule

module Counter_arb#(parameter mx_cnt = 32) (count, clk, rst);
  output reg [$clog2(mx_cnt)-1:0] count;
  input clk;
  input rst;

 
     always @(posedge clk or posedge rst)begin
       if (rst)begin
           count <= 0;
       end else begin
         if(count == mx_cnt-1)begin
           count <= 0;
         end else begin
           count <= count + 1;
         end
       end
     end
endmodule
 
module prll_bus_gnrtr #(parameter pck_sz = 40, parameter num_ntrfs=4, parameter broadcast = {3{1'b1}}, parameter fifo_depth=4)(
  input clk,
  input reset,
  input[pck_sz-1:0] data_in[num_ntrfs-1:0],
  input pop[num_ntrfs-1:0],
  input push[num_ntrfs-1:0],
  output pndng[num_ntrfs-1:0],
  output [pck_sz-1:0] data_out[num_ntrfs-1:0]
);
  wire pop_i;
  wire push_i;
  wire [num_ntrfs-1:0]pndng_i;
  wire [$clog2(num_ntrfs)-1:0]trn;
  wire [pck_sz-1:0] data_in_i;
  wire [pck_sz-1:0] data_out_i[num_ntrfs-1:0];
  
  genvar i;
  generate
    for(i=0;i<num_ntrfs; i=i+1)begin:_nu_
      router_bus_interface #(.pck_sz(pck_sz),.num_ntrfs(num_ntrfs), .ntrfs_id(i),.broadcast(broadcast),.fifo_depth(fifo_depth)) rtr_ntrfs_ (
        .clk(clk),
        .reset(reset),
        .data_in_i(data_in_i),
        .trn(trn),
        .pop(pop[i]),
        .pop_i(pop_i),
        .push_i(push_i),
        .push(push[i]),
        .data_in(data_in[i]),
        .data_out_i(data_out_i[i]),
        .data_out(data_out[i]),
        .pndng(pndng[i]),
        .pndng_i(pndng_i[i])
      );
    end
  endgenerate
  riscv_bus_arbiter #(.num_ntrfs(num_ntrfs),.pck_sz(pck_sz)) arbitro(
  .reset(reset),
  .clk(clk),
  .pndng_i(pndng_i),
  .data_out_i(data_out_i),
  .trn(trn),
  .push_i(push_i),
  .pop_i(pop_i),
  .data_in_i(data_in_i)
);
endmodule 


module router_bus_interface #(parameter pck_sz = 40, parameter num_ntrfs=4, parameter [2:0]ntrfs_id = 0, parameter broadcast = {3{1'b1}}, parameter fifo_depth=4) (
  input clk,
  input reset,
  input [pck_sz-1:0]data_in_i,
  input [$clog2(num_ntrfs)-1:0]trn,
  input pop_i,
  input push_i,
  input pop,
  input push,
  input [pck_sz-1:0]data_in,
  output [pck_sz-1:0]data_out_i,
  output [pck_sz-1:0]data_out,
  output pndng,
  output pndng_i
  );
  logic pre_psh;
  logic pre_pop;
  logic psh;
  logic popin;

  fifo_flops_no_full #(.depth(fifo_depth),.bits(pck_sz))fifo_out (
    .Din(data_in_i),
    .Dout(data_out),
    .push(psh),
    .pop(pop),
    .clk(clk),
    .pndng(pndng),
    .rst(reset)
  );

  fifo_flops_no_full #(.depth(fifo_depth),.bits(pck_sz))fifo_in (
    .Din(data_in),
    .Dout(data_out_i),
    .push(push),
    .pop(popin),
    .clk(clk),
    .pndng(pndng_i),
    .rst(reset)
  );
  
  assign psh = pre_psh & push_i;
  assign popin = pre_pop & pop_i;
  assign pre_psh = ((ntrfs_id == data_in_i[pck_sz-1:pck_sz-3])|(data_in_i[pck_sz-1:pck_sz-3]== broadcast)&(pre_pop == 0))?1:0; 
  assign pre_pop = (ntrfs_id == trn)?1:0;
  
endmodule

module rtr_rbtr_cntrl (
  input clk,
  input rst,
  input pndng,
  output logic cnt_en,
  output logic push_i,
  output logic pop_i
);
 reg [1:0]cur_st;
 logic [1:0]nxt_st;
 parameter rst_st = 0;
 parameter psh1_st = 1;
 parameter cnt1_st = 2;
 parameter pop1_st = 3;
 
 //lógica de siguiente estado
 always_comb begin
   case(cur_st)
     rst_st: begin
       nxt_st <= pndng?psh1_st:cnt1_st;
     end 
     psh1_st: nxt_st <= pop1_st;
     pop1_st: nxt_st <= cnt1_st;
     cnt1_st: nxt_st <= rst_st;
     default: nxt_st <= rst_st;
  endcase
 end
 //refrescamiento de la máquina de estados
 always@(posedge clk or posedge rst) begin
   cur_st <= rst?rst_st:nxt_st;
 end
 // lógica de salida
 always_comb begin
  case(cur_st)
    rst_st: begin
      cnt_en <= 0;
      push_i <= 0;
      pop_i <= 0;
    end
    psh1_st: begin
      cnt_en <= 0;
      push_i <= 1;
      pop_i <= 0;
    end
    pop1_st: begin
      cnt_en <= 0;
      push_i <= 0;
      pop_i <= 1;
    end
    cnt1_st: begin
      cnt_en <=1;
      push_i <= 0;
      pop_i <= 0;
    end
  endcase
 end

endmodule

module tri_buf_mux #(parameter size =8) (
    input [size-1:0]a,
    output [size-1:0]b,
    input en
);
    
   assign b = (en)?a:{size{1'bz}};
     	  	 
endmodule

module param_mux #(parameter num_slct_lns = 2, parameter pck_sz = 4) (
  input  [num_slct_lns-1:0] select,
  input  [pck_sz-1:0]input_signal[(2**num_slct_lns)-1:0],
  output [pck_sz-1:0] out
);
  logic hot_bit_slct[(2**num_slct_lns)-1:0];
  genvar i;
  generate
      for(i=0;i<(2**num_slct_lns); i=i+1)begin:_nu_
         always_comb begin
           hot_bit_slct[i] <= (i == select)?{1'b1}:{1'b0};
         end
           tri_buf_mux #(.size(pck_sz)) buf_select (.a(input_signal[i]),.b(out),.en(hot_bit_slct[i])); 
      end    
  endgenerate
endmodule

module param_mux_single_bit #(parameter num_slct_lns = 2) (
  input  [num_slct_lns-1:0] select,
  input  [(2**num_slct_lns)-1:0]input_signal,
  output out
);
  logic hot_bit_slct[(2**num_slct_lns)-1:0];
  genvar i;
  generate
      for(i=0;i<(2**num_slct_lns); i=i+1)begin:_nu_
         always_comb begin
           hot_bit_slct[i] <= (i == select)?{1'b1}:{1'b0};
         end
           tri_buf buf_select (.a(input_signal[i]),.b(out),.en(hot_bit_slct[i])); 
      end    
  endgenerate
endmodule

module riscv_bus_arbiter #(parameter num_ntrfs=4, parameter pck_sz = 32) (
  input reset,
  input clk,
  input [num_ntrfs-1:0]pndng_i,
  input [pck_sz-1:0]data_out_i[num_ntrfs-1:0],
  output [$clog2(num_ntrfs)-1:0]trn,
  output push_i,
  output pop_i,
  output logic [pck_sz-1:0]data_in_i
);
  logic clk_rtr_rbtr_cntrl;
  logic clk_en;
  logic cnt_en;
  logic pndng;

Counter_arb #(.mx_cnt(num_ntrfs)) contador(
  .count(trn), 
  .clk(cnt_en), 
  .rst(reset)
 );

//  always_comb begin
//    clk_rtr_rbtr_cntrl <= clk & clk_en;
//    clk_en <= (pndng_i == 0)?0:1;
//  end

always_comb begin
  case(trn) // synopsys infer_mux
    0: begin
      pndng <= pndng_i[0];
      data_in_i <= data_out_i[0];
    end
    1: begin
      pndng <= pndng_i[1];
      data_in_i <= data_out_i[1];
    end
    2: begin
      pndng <= pndng_i[2];
      data_in_i <= data_out_i[2];
    end
    default: begin
      pndng <= 0;
      data_in_i <=0;
    end
  endcase
end 
//param_mux_single_bit #(.num_slct_lns($clog2(num_ntrfs))) pndng_mx(
// .select(trn),
// .input_signal(pndng_i),
// .out(pndng)
//);


//param_mux #(.num_slct_lns($clog2(num_ntrfs)),.pck_sz(pck_sz)) data_mx(
// .select(trn),
// .input_signal(data_out_i),
// .out(data_in_i)
//);
  
rtr_rbtr_cntrl arbitro (
  .clk(clk),
  .rst(reset),
  .pndng(pndng),
  .cnt_en(cnt_en),
  .push_i(push_i),
  .pop_i(pop_i)
);
endmodule

module tec_riscv_bus_2 #(parameter bits = 65, parameter broadcast = {3{1'b1}}) (
  input clk,
  input reset,
  output logic pndng_mbc,
  output logic pndng_spi,
  output logic pndng_uart,
  input  push_mbc,
  input  push_spi,
  input  push_uart,
  input  pop_mbc,
  input  pop_spi,
  input  pop_uart,
  output logic  [bits-1:0] D_pop_mbc,
  output logic  [bits-1:0] D_pop_spi,
  output logic  [bits-1:0] D_pop_uart,
  input [bits-1:0] D_push_mbc,
  input [bits-1:0] D_push_spi,
  input [bits-1:0] D_push_uart
);
  logic [bits-1:0] data_in[2:0];
  logic push[2:0];
  logic pop[2:0];
  wire pndng[2:0];
  wire [bits-1:0] data_out[2:0];

  always_comb begin
    data_in[0] <= D_push_mbc;
    data_in[1] <= D_push_spi;
    data_in[2] <= D_push_uart;
    D_pop_mbc <=  data_out[0];
    D_pop_spi <=  data_out[1];
    D_pop_uart <= data_out[2];
    pop[0] <= pop_mbc;
    pop[1] <= pop_spi;
    pop[2] <= pop_uart;
    push[0] <= push_mbc;
    push[1] <= push_spi;
    push[2] <= push_uart;
    pndng_mbc <= pndng[0];
    pndng_spi <= pndng[1];
    pndng_uart<= pndng[2];
    
    
  end

prll_bus_gnrtr #(.pck_sz(bits),.num_ntrfs(3),.broadcast(broadcast),.fifo_depth(2)) bus_paralelo_arbtr(
  .clk(clk),
  .reset(reset),
  .data_in(data_in),
  .pop(pop),
  .push(push),
  .pndng(pndng),
  .data_out(data_out)
);

endmodule
