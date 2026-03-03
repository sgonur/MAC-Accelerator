module mac_core (
    input       clk,
    input       rst_n,
    input       start_bit,
    input       [3:0] a_i,
    input       [3:0] b_i,
    output wire [7:0] c_o,
    output wire done_bit
);

    typedef enum logic [2:0] {
        IDLE,
        LOAD,
        COMPUTE,
        DONE
    } state_t;

    state_t state;
    logic [1:0] count;
    // needs to be 8 bits as if it was 4 it would shift out and become all 0s too early
    logic [7:0] a_reg, b_reg;
    logic [7:0] acc_total;


    fsm main_fsm (
        .clk   (clk),
        .rst_n (rst_n),
        .start_bit (start_bit),
        .count (count),
        .state (state)
    );


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 2'd0;
        else begin
            case (state)
                IDLE,
                LOAD:    count <= 2'd0;
                COMPUTE: count <= count + 1'b1;
                DONE:    count <= count;
                default: count <= 2'd0;
            endcase
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 4'd0;
            b_reg <= 4'd0;
            acc_total <= 8'd0;
        end else begin
            case (state)
                LOAD: begin
                    a_reg <= a_i;
                    b_reg <= b_i;
                    acc_total <= 8'd0;
                end

                COMPUTE: begin
                    if (b_reg[0])
                        acc_total <= acc_total + a_reg;

                    a_reg <= a_reg << 1;
                    b_reg <= b_reg >> 1;
                end

                default: begin
                end
            endcase
        end
    end

    assign c_o = acc_total;
    assign done_bit = (state == DONE);

endmodule
