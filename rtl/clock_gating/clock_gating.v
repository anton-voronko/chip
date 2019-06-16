module clock_gating
  (
   input clk_i,
   input enable_i,
   input testmode_i,
   output clk_o
   );

   wire   clock_gated;
   reg 	  latch;
   
   always @(*)
     begin
	if (!clk_i) 
	  begin
	     latch = enable_i | testmode_i;
	  end
     end

   assign clock_gated = clk_i & latch;
   assign clk_o = clock_gated;
     
endmodule
