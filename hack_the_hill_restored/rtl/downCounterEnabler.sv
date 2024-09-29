module downCounterEnabler #(parameter N=8) (
    input wire clk,
    input wire enable,
    input wire n_reset,
    output wire modifyPeriod
);

    logic [N-1:0] counter;
    logic tempModify;

    assign modifyPeriod = tempModify;

    always_ff @(posedge clk, negedge n_reset) begin
        if (~n_reset)
            counter <= {N{1'b1}};  
			
        else if (enable & counter != 'b0)
            counter <= counter - 1;

        tempModify = (counter != 'b0 && counter != {N{1'b1}});  
    end

endmodule