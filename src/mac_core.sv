module mac_core (
    input clk,
    input rst_n,
    input start_bit,
    input  end_bit,
    input [3:0] a_i,
    input [3:0] b_i,
    output wire [7:0] c_o,
    output wire done_bit
);
    // FSM Stuff
    logic [2:0] state;
    logic [1:0] count;
    
    fsm main_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .start_bit(start_bit),
        .count(count),
        .state_change(state)
    );

    logic [3:0] a_reg;
    logic [3:0] b_reg;
    logic [7:0] acc_total;

    // Keep track of count
    always_ff @(posedge clk) begin
        if (!rst_n)
            count <= 2'd0;
        else begin
            case (state)
                IDLE : count <= 2'd0;
                LOAD : count <= 2'd0;
                COMPUTE : count <= count + 1;
                DONE : count <= count;
            endcase
        end
    end

    // Main Logic
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            a_reg <= 0;
            b_reg <= 0;
            acc_total <= 0;
        end else begin
            case (state)
                LOAD : begin
                    a_reg <= a_i;
                    b_reg <= b_i;
                    acc_total <= 0;
                end

                COMPUTE : begin
                    if (b_reg[0])
                        acc_total <= acc_total + a_reg;
                    a_reg <= a_reg << 1;
                    b_reg <= b_reg >> 1;
                end

            endcase
        end
    end

    assign done_bit = (state == DONE);

endmodule