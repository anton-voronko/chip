module shifter
  (
   input 	 clk_i,
   input 	 reset_ni,
   input 	 rigth_left_i,
   input 	 arith_logic_i,
   input 	 write_pulse_i,
   input [3:0] 	 shift_amount_i,
   input [15:0]  data_i,

   output 	 ready_pulse_o,
   output [15:0] data_o
   );

   reg [3:0] 	 bit_counter;
   reg [15:0] 	 data;
   reg 		 ready_pulse;
            
   always @ ( posedge clk_i or negedge reset_ni )
     begin
        if ( ~reset_ni ) 
 	  begin
	     bit_counter <= 4'b0;
	  end
	else if ( write_pulse_i )
	  begin
	     bit_counter <= shift_amount_i;
	  end
	else if ( bit_counter != 4'b0 )
	  begin
	     bit_counter <= bit_counter - 1'b1;
	  end 
     end 

   always @ ( posedge clk_i or negedge reset_ni )
     begin
        if ( ~reset_ni ) 
 	  begin
	     data <= 16'b0;
	  end
	else if ( write_pulse_i )
	  begin
	     data <= data_i;
	  end
	else if ( bit_counter != 4'b0 )
	  begin
	     if ( rigth_left_i & arith_logic_i )
	       begin
		  data <= {data[15],data[15:1]};
	       end
	     else if ( rigth_left_i )
	       begin
		  data <= {1'b0,data[15:1]};
	       end
	     else
	       begin
		  data <= {data[14:0],1'b0};
	       end 
	  end
     end   

   always @ ( posedge clk_i or negedge reset_ni )
     begin
        if ( ~reset_ni ) 
 	  begin
	     ready_pulse <= 1'b0;
	  end
	else if ( bit_counter == 4'd1 ) 
	  begin 
	     ready_pulse <= 1'b1;
	  end
	else
	  begin
	     ready_pulse <= 1'b0;
	  end 
     end 

   assign ready_pulse_o = ready_pulse;
   assign data_o = data;
      
endmodule
