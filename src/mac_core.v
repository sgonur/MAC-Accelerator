module mac_core (
	clk,
	rst_n,
	start_bit,
	a_i,
	b_i,
	c_o,
	done_bit
);
	input clk;
	input rst_n;
	input start_bit;
	input [3:0] a_i;
	input [3:0] b_i;
	output wire [7:0] c_o;
	output wire done_bit;
	wire [2:0] state;
	reg [1:0] count;
	reg [7:0] a_reg;
	reg [7:0] b_reg;
	reg [7:0] acc_total;
	fsm main_fsm(
		.clk(clk),
		.rst_n(rst_n),
		.start_bit(start_bit),
		.count(count),
		.state(state)
	);
	always @(posedge clk or negedge rst_n)
		if (!rst_n)
			count <= 2'd0;
		else
			case (state)
				3'd0, 3'd1: count <= 2'd0;
				3'd2: count <= count + 1'b1;
				3'd3: count <= count;
				default: count <= 2'd0;
			endcase
	always @(posedge clk or negedge rst_n)
		if (!rst_n) begin
			a_reg <= 4'd0;
			b_reg <= 4'd0;
			acc_total <= 8'd0;
		end
		else
			case (state)
				3'd1: begin
					a_reg <= a_i;
					b_reg <= b_i;
					acc_total <= 8'd0;
				end
				3'd2: begin
					if (b_reg[0])
						acc_total <= acc_total + a_reg;
					a_reg <= a_reg << 1;
					b_reg <= b_reg >> 1;
				end
				default:
					;
			endcase
	assign c_o = acc_total;
	assign done_bit = state == 3'd3;
endmodule