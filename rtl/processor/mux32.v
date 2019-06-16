module mux32
  (
   input [4:0] sel_i,
   input [31:0] data_i,

   output data_o
   );

   genvar i;

   wire [1:0] data_mux16_w;
   wire       data_mux32_w;

   assign data_mux32_w = (sel_i[4]) ? data_mux16_w[1] : data_mux16_w[0];
   assign data_o = data_mux32_w;
 
generate
   for(i=0;i<2;i=i+1)
     begin : mux16
	mux16 mux16
	 (
	  .sel_i(sel_i[3:0]),
	  .data_i(data_i[(i*16+15)-:16]),
	  .data_o(data_mux16_w[i])
	  );
     end 
endgenerate  
   
endmodule

module mux16
  (
   input [3:0] 	sel_i,
   input [15:0] data_i,

   output 	data_o
   );

   genvar 	i;

   wire [3:0] 	data_mux4_w;
   wire [1:0] 	data_mux8_w;
   wire 	data_mux16_w;
   
   assign data_mux8_w[0] = (sel_i[2]) ? data_mux4_w[1] : data_mux4_w[0];
   assign data_mux8_w[1] = (sel_i[2]) ? data_mux4_w[3] : data_mux4_w[2];
   assign data_mux16_w = (sel_i[3]) ? data_mux8_w[1] : data_mux8_w[0];
      
generate
   for(i=0;i<4;i=i+1)
     begin : mux4
	mux4 mux4
	 (
	  .sel_i(sel_i[1:0]),
	  .data_i(data_i[(i*4+3)-:4]),
	  .data_o(data_mux4_w[i])
	  );
     end 
endgenerate

   assign data_o = data_mux16_w;
      
endmodule

module mux4
  (
   input [1:0] sel_i,
   input [3:0] data_i,

   output data_o
   );

   reg 	  data_v;

   always @(*)
     case(sel_i)
       2'b00 : data_v = data_i[0];
       2'b01 : data_v = data_i[1];
       2'b10 : data_v = data_i[2];
       2'b11 : data_v = data_i[3];
     endcase

   assign data_o = data_v;
      
endmodule
   
