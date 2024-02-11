`default_nettype none
`timescale 1ns/1ns
module encoder #(
    parameter WIDTH = 8,
    parameter MAX = 256,
    parameter INCREMENT = 1
)(
    input clk,
    input reset,
    input a,
    input b,
    output reg [WIDTH-1:0] value
);
    reg old_a, old_b;
    always @(posedge clk) begin
        if (reset) begin
            old_a <= 0;
            old_b <= 0;
            value <= 0;
        end else begin
            old_a <= a;
            old_b <= b;
            case ({a,old_a,b,old_b})
                4'b1000, 4'b0111: begin
                    if (value != MAX)
                        value <= value + INCREMENT;
                end
                4'b0010, 4'b1101: begin
                    if (|value)
                        value <= value - INCREMENT;
                end
                default: value <= value;
            endcase
        end
    end
endmodule
