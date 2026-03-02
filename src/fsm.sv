module fsm (
    input logic clk,
    input logic rst_n,
    input logic start_bit,
    input logic [1:0] count,
    ouput logic [2:0] state_change
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
                if (count == 3)
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

    // Debug logic
    always_comb begin
        state_change = currentState;
    end

endmodule