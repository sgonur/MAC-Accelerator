module fsm (
    input clk,
    input rst_n,
    input start_bit,
    input [1:0] count,
    output wire [2:0] state
);
    typedef enum logic [2:0] {
        IDLE, LOAD, COMPUTE, DONE
    } State;

    State currentState, nextState;

    always_ff @(posedge clk) begin
        if(!rst_n) begin
            currentState <= IDLE;
        end else begin
            currentState <= nextState;
        end
    end

    always_comb begin
        case (currentState)
            IDLE : begin
                if (start_bit)
                    nextState = LOAD;
                else
                    nextState = IDLE;
            end

            LOAD : begin
                // Should auto move to Compute, just wait a clock cycle
                nextState = COMPUTE;
            
            end

            COMPUTE : begin
                // Only go to DONE if the 4 calculations are done
                if (count == 2'd3)
                    nextState = DONE;
                else 
                    nextState = COMPUTE;
            end

            DONE : begin
                if (!start_bit)
                    nextState = IDLE;
                else
                    nextState = DONE;
            end    
        endcase
    end

    assign state = currentState;

endmodule
