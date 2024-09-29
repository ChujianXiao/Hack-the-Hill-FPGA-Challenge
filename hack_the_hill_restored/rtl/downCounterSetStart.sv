module downCounterSetStart #(parameter N=8) (
    input wire clk,
    input wire enable,
    input wire n_reset,
    input wire[N-1:0] start,
    output wire startBar
);

    logic [N-1:0] counter;
    logic tempstartBar;

    assign startBar = tempstartBar;

    always_ff @(posedge clk, negedge n_reset) begin
        if (~n_reset)
            counter <= start;  
			
        else if (enable & counter != 'b0)
            counter <= counter - 1;

        tempstartBar = (counter == 'b0);  
    end

endmodule