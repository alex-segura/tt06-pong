`default_nettype none
`timescale 1ns/1ns
module pong (
    input wire reset,
    input wire vsync,
    input wire [9:0] paddle1_next,
    input wire [9:0] paddle2_next,
    input wire [9:0] hpos,
    input wire [9:0] vpos,
    input wire de,
    output wire r,
    output wire g,
    output wire b
);
    localparam BALL_SIZE = 4;
    localparam BALL_SPEED = 4;
    localparam PADDLE_WIDTH = 4;
    localparam PADDLE_HEIGHT = 50;
    localparam PADDLE1_HPOS = 10;
    localparam PADDLE2_HPOS = 626;
    localparam NET_WIDTH = 3;
    localparam NET_HPOS = 320;

    localparam ball_v_init = 240;
    localparam ball_h_init = 320;

    reg [9:0] ball_hpos;
    reg [9:0] ball_vpos;
    reg ball_h_dir, ball_v_dir;

    reg [9:0] paddle1_vpos;
    reg [9:0] paddle2_vpos;

    wire [9:0] ball_hdiff = hpos - ball_hpos;
    wire [9:0] ball_vdiff = vpos - ball_vpos;
    wire ball_hgfx = ball_hdiff < BALL_SIZE;
    wire ball_vgfx = ball_vdiff < BALL_SIZE;
    wire ball_gfx = ball_hgfx && ball_vgfx;

    wire [9:0] p1_hdiff = hpos - PADDLE1_HPOS;
    wire [9:0] p1_vdiff = vpos - paddle1_vpos;
    wire p1_hgfx = p1_hdiff < PADDLE_WIDTH;
    wire p1_vgfx = p1_vdiff < PADDLE_HEIGHT;
    wire paddle1_gfx = p1_hgfx && p1_vgfx;

    wire [9:0] p2_hdiff = hpos - PADDLE2_HPOS;
    wire [9:0] p2_vdiff = vpos - paddle2_vpos;
    wire p2_hgfx = p2_hdiff < PADDLE_WIDTH;
    wire p2_vgfx = p2_vdiff < PADDLE_HEIGHT;
    wire paddle2_gfx = p2_hgfx && p2_vgfx;

    wire net_hgfx = hpos - NET_HPOS < NET_WIDTH;
    wire net_vgfx = vpos[3];
    wire net_gfx = net_hgfx && net_vgfx;

    wire ball_collide_paddle1 =
         ball_vpos - paddle1_vpos < PADDLE_HEIGHT + BALL_SIZE &&
         ball_hpos - PADDLE1_HPOS < PADDLE_WIDTH + BALL_SIZE;
    wire ball_collide_paddle2 =
         ball_vpos - paddle2_vpos < PADDLE_HEIGHT + BALL_SIZE &&
         PADDLE2_HPOS - ball_hpos < PADDLE_WIDTH + BALL_SIZE;
    wire ball_collide_paddle = ball_collide_paddle1 || ball_collide_paddle2;

    wire ball_v_collide = ball_vpos >= 480 - BALL_SIZE;
    wire ball_h_collide = ball_hpos >= 640 - BALL_SIZE;

    wire [9:0] ball_h_move = ball_h_dir ? BALL_SPEED : -BALL_SPEED;
    wire [9:0] ball_v_move = ball_v_dir ? BALL_SPEED : -BALL_SPEED;

    always @(posedge vsync) begin
        if (reset) begin
            ball_h_dir = 0;
            ball_v_dir = 0;
            paddle1_vpos <= paddle1_next;
            paddle2_vpos <= paddle2_next;
        end else begin
            if (ball_h_collide || ball_collide_paddle) begin
                ball_h_dir = ~ball_h_dir;
            end else if (ball_v_collide) begin
                ball_v_dir = ~ball_v_dir;
            end
            paddle1_vpos <= paddle1_next;
            paddle2_vpos <= paddle2_next;
            ball_hpos <= ball_h_collide ? ball_h_init : ball_hpos + ball_h_move;
            ball_vpos <= ball_h_collide ? ball_v_init : ball_vpos + ball_v_move;
        end
    end

    assign r = de && (ball_gfx || paddle1_gfx || paddle2_gfx || net_gfx);
    assign g = de && (ball_gfx || paddle1_gfx || paddle2_gfx || net_gfx);
    assign b = de && (ball_gfx || paddle1_gfx || paddle2_gfx || net_gfx);
endmodule
