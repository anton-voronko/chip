module registers_32x32
  (
   input       clk_i,
   input       reset_ni,
   input       write_enable_i,
   input [4:0] register_addr_a_i,
   input [4:0] register_addr_b_i,
   input [4:0] register_write_i,
   input [31:0] write_data_i,

   output [31:0] read_data_a_o,
   output [31:0] read_data_b_o
   );

   integer 	 i;

   wire [4:0] 	 enable_data_w;
      
   reg 		 enable_register_v [1:31];
   reg [31:0] 	 register [1:31];
   
   assign enable_data_w = register_write_i & {5{write_enable_i}};
      
   always @(*)
     begin
	for(i=1;i<32;i=i+1)
	  begin
	     enable_register_v[i] = 1'b0;
	  end
	for(i=1;i<32;i=i+1)
	  begin
	     if (enable_data_w == i) enable_register_v[i] = 1'b1;
	  end 
     end 

   always @(posedge clk_i or negedge reset_ni)
     begin
	if (!reset_ni)
	  for(i=1;i<32;i=i+1)
	    begin
	       register[i] <= 32'b0;
	    end
	else
	  for(i=1;i<32;i=i+1)
	    begin
	       if (enable_register_v[i])
		 begin
		    register[i] <= write_data_i;
		 end
	    end 
     end 

   wire [31:0] decoded_read_a_data_w;
   wire [31:0] decoded_read_b_data_w;

   genvar      j;

generate
   for(j=0;j<32;j=j+1)
     begin : multiplexer
	mux32 mux32_a
	 (
	  .sel_i(register_addr_a_i),
	  .data_i({register[31][j],
		   register[30][j],
		   register[29][j],
		   register[28][j],
		   register[27][j],
		   register[26][j],
		   register[25][j],
		   register[24][j],
		   register[23][j],
		   register[22][j],
		   register[21][j],
		   register[20][j],
		   register[19][j],
		   register[18][j],
		   register[17][j],
		   register[16][j],
		   register[15][j],
		   register[14][j],
		   register[13][j],
		   register[12][j],
		   register[11][j],
		   register[10][j],
		   register[9][j],
		   register[8][j],
		   register[7][j],
		   register[6][j],
		   register[5][j],
		   register[4][j],
		   register[3][j],
		   register[2][j],
		   register[1][j],
		   1'b0}),
	  .data_o(decoded_read_a_data_w[j])
	  );

	mux32 mux32_b
	 (
	  .sel_i(register_addr_b_i),
	  .data_i({register[31][j],
		   register[30][j],
		   register[29][j],
		   register[28][j],
		   register[27][j],
		   register[26][j],
		   register[25][j],
		   register[24][j],
		   register[23][j],
		   register[22][j],
		   register[21][j],
		   register[20][j],
		   register[19][j],
		   register[18][j],
		   register[17][j],
		   register[16][j],
		   register[15][j],
		   register[14][j],
		   register[13][j],
		   register[12][j],
		   register[11][j],
		   register[10][j],
		   register[9][j],
		   register[8][j],
		   register[7][j],
		   register[6][j],
		   register[5][j],
		   register[4][j],
		   register[3][j],
		   register[2][j],
		   register[1][j],
		   1'b0}),
	  .data_o(decoded_read_b_data_w[j])
	  );
     end 
endgenerate 

   assign read_data_a_o = decoded_read_a_data_w;
   assign read_data_b_o = decoded_read_b_data_w;
   
endmodule 
