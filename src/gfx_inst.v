`timescale 1ns / 1ps


module gfx (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire BTN1,
    input wire BTN2,
    input wire BTN3,
    input wire i_v_sync,
    output reg [7:0] o_red,
    output reg [7:0] o_green,
    output reg [7:0] o_blue

);
    wire bg_hit, sprite_hit, sprite2_hit;
    wire [7:0] bg_red;
    wire [7:0] bg_green;
    wire [7:0] bg_blue;
    wire [7:0] sprite_red;
    wire [7:0] sprite_green;
    wire [7:0] sprite_blue;
    wire [7:0] sprite2_red;
    wire [7:0] sprite2_green;
    wire [7:0] sprite2_blue;

    test_card_simple test_card_simple_1 (
        .i_x     (i_x),
        .o_red   (bg_red),
        .o_green (bg_green),
        .o_blue  (bg_blue),
        .o_bg_hit(bg_hit)
    );

    sprite_compositor sprite_compositor_1 (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (sprite_red),
        .o_green     (sprite_green),
        .o_blue      (sprite_blue),
        .o_sprite_hit(sprite_hit)
    );

    sprite_compositor_2 sprite_compositor_2 (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_btn1      (BTN1),
        .i_btn2      (BTN2),
        .i_btn3      (BTN3),
        .i_v_sync    (i_v_sync),
        .o_red       (sprite2_red),
        .o_green     (sprite2_green),
        .o_blue      (sprite2_blue),
        .o_sprite_hit(sprite2_hit)
    );

    always @(*) begin
        if (sprite_hit == 1) begin
            o_red   = sprite_red;
            o_green = sprite_green;
            o_blue  = sprite_blue;
        end else if (sprite2_hit == 1) begin
            o_red   = sprite2_red;
            o_green = sprite2_green;
            o_blue  = sprite2_blue;
        end else begin
            o_red   = bg_red;
            o_green = bg_green;
            o_blue  = bg_blue;
        end

    end

endmodule
