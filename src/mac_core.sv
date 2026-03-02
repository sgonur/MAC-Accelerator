module mac_core (
    input clk,
    input rst_n,
    input start_bit,
    input  end_bit,
    input [3:0] a,
    input [3:0] b,
    output wire [7:0] c
);

    logic [2:0] state;
    logic [1:0] count;
    
    fsm main_fsm (
        .clk(clk),
        .rst_n(rst_n),
        .start_bit(start_bit),
        .count(count),
        .state_change(state)
    );

    

endmodule