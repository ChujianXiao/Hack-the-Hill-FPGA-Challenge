module signalModifier(
    input i_clk,
    input[19:0] i_vdat_colour,
    input[3:0] i_fvht,
    output[19:0] o_updated_colour
);
	
	 logic[12:0] incrementer;
    logic modify_period;
    logic[9:0] modified_colour;
	 logic vertical_blank;
	 logic horizontal_blank;
	 logic startBar;

    assign vertical_blank = i_fvht[2]; 
    assign horizontal_blank = i_fvht[1];
	
	 initial begin
		incrementer = 'b0;
	 end
    
    downCounterEnabler #(8) downCounterEnabler(
        .clk(i_clk),
        .enable(startBar),
        .n_reset(~horizontal_blank),
        .modifyPeriod(modify_period)
    );

    mux2 #(10) selectOutdata (
        .i_select(modify_period),
		  .i_input0(i_vdat_colour[9:0]),
		  .i_input1(modified_colour),
        .o_output(o_updated_colour[9:0])
    );

    complement2 colourInverter(
        .i(i_vdat_colour[9:0]),
        .o(modified_colour)
    );
	 
	 downCounterSetStart #(12) delayer(
		.clk(i_clk),
		.enable(1),
		.n_reset(~horizontal_blank),
		.start(incrementer),
		.startBar(startBar)
    );
	 
	 assign o_updated_colour[19:10] = i_vdat_colour[19:10];
	 
	 /*always_ff @(posedge vertical_blank) begin
		if(incrementer == 3800) begin
			incrementer <= 'b0;
		end else begin
			incrementer <= incrementer + 1;
		end
	 end */
	 
	 logic up;
	 
	 /*always_ff @(posedge vertical_blank) begin
		if(incrementer == 3800) begin
			//incrementer <= 'b0;
			up <= 1;
			incrementer <= incrementer - 1;
		end else if(incrementer == '1) begin
			up <= 0;
			incrementer <= incrementer + 1;
		end else begin
			if(up == 1'b0) begin
				incrementer <= incrementer + 1;
			end else
				incrementer <= incrementer - 1;
		end
	 end*/
	 
	 
	 logic vertical_blank_last;
	 always_ff @(posedge i_clk) begin
		 vertical_blank_last <= vertical_blank;
	 end

	 wire vertical_blank_rising_edge = ~vertical_blank_last & vertical_blank;

	 always_ff @(posedge i_clk) begin
		 if(vertical_blank_rising_edge) begin
				if(incrementer == 3800) begin
					//incrementer <= 'b0;
					up <= 1;
					incrementer <= incrementer - 1;
				end else if(incrementer == '1) begin
					up <= 0;
					incrementer <= incrementer + 1;
				end else begin
					if(up == 1'b0) begin
						incrementer <= incrementer + 1;
					end else
						incrementer <= incrementer - 1;
				end
		  end
	 end
    
endmodule