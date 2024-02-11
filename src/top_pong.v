`default_nettype none
`timescale 1ns/1ns
module top_pong #(
    parameter CORDW=10
) (
    input wire clk,
    input wire sim_rst,
    input wire [9:0] paddle1_next,
    input wire [9:0] paddle2_next,
    output wire [CORDW-1:0] sdl_sx,
    output wire [CORDW-1:0] sdl_sy,
    output wire sdl_de,
    output wire [7:0] sdl_r,
    output wire [7:0] sdl_g,
    output wire [7:0] sdl_b
);
    wire pixel;
    wire hsync, vsync, de;
    wire [CORDW-1:0] hpos;
    wire [CORDW-1:0] vpos;
    hvsync_generator hvsync_generator(
        .clk(clk),
        .reset(sim_rst),
        .hsync(hsync),
        .vsync(vsync),
        .sx(hpos),
        .sy(vpos),
        .de(de));
    pong pong(
        .clk(clk),
        .reset(sim_rst),
        .vsync(vsync),
        .hpos(hpos),
        .vpos(vpos),
        .de(de),
        .paddle1_next(paddle1_next),
        .paddle2_next(paddle2_next),
        .pixel(pixel));
    assign sdl_sx = hpos;
    assign sdl_sy = vpos;
    assign sdl_de = de;
    assign sdl_r = pixel ? 8'hff : 8'h00;
    assign sdl_g = pixel ? 8'hff : 8'h00;
    assign sdl_b = pixel ? 8'hff : 8'h00;
endmodule
