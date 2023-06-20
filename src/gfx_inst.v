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
    wire [7:0] bg_red, bg_green, bg_blue;
    wire [7:0] glacier1_red, glacier1_green, glacier1_blue;
    wire [7:0] glacier2_red, glacier2_green, glacier2_blue;
    wire [7:0] penguin_red, penguin_green, penguin_blue;
    wire glacier1_hit, glacier2_hit, penguin_hit;

    background_img bgimg (
        .i_x    (i_x),
        .i_y    (i_y),
        .o_red  (bg_red),
        .o_green(bg_green),
        .o_blue (bg_blue)
    );

    sprite_glacier1 glacier1 (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (glacier1_red),
        .o_green     (glacier1_green),
        .o_blue      (glacier1_blue),
        .o_sprite_hit(glacier1_hit)
    );

    sprite_glacier2 glacier2 (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (glacier2_red),
        .o_green     (glacier2_green),
        .o_blue      (glacier2_blue),
        .o_sprite_hit(glacier2_hit)
    );

    sprite_penguin penguin (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_btn1      (BTN1),
        .i_btn2      (BTN2),
        .i_btn3      (BTN3),
        .i_v_sync    (i_v_sync),
        .o_red       (penguin_red),
        .o_green     (penguin_green),
        .o_blue      (penguin_blue),
        .o_sprite_hit(penguin_hit)
    );

    always @(*) begin
        if (glacier1_hit == 1) begin
            o_red   = glacier1_red;
            o_green = glacier1_green;
            o_blue  = glacier1_blue;
        end else if (glacier2_hit == 1) begin
            o_red   = glacier2_red;
            o_green = glacier2_green;
            o_blue  = glacier2_blue;
        end else if (penguin_hit == 1) begin
            o_red   = penguin_red;
            o_green = penguin_green;
            o_blue  = penguin_blue;
        end else begin
            o_red   = bg_red;
            o_green = bg_green;
            o_blue  = bg_blue;
        end

    end

endmodule
