module fsm (
	clk,
	rst_n,
	start_bit,
	count,
	state
);
	reg _sv2v_0;
	input clk;
	input rst_n;
	input start_bit;
	input [1:0] count;
	output wire [2:0] state;
	reg [2:0] currentState;
	reg [2:0] nextState;
	always @(posedge clk)
		if (!rst_n)
			currentState <= 3'd0;
		else
			currentState <= nextState;
	always @(*) begin
		nextState = 3'd0;
		case (currentState)
			3'd0:
				if (start_bit)
					nextState = 3'd1;
				else
					nextState = 3'd0;
			3'd1: nextState = 3'd2;
			3'd2:
				if (count == 2'd3)
					nextState = 3'd3;
				else
					nextState = 3'd2;
			3'd3:
				if (!start_bit)
					nextState = 3'd0;
				else
					nextState = 3'd3;
		endcase
	end
	assign state = currentState;
	initial _sv2v_0 = 0;
endmodule