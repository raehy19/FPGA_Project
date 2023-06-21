`timescale 1ns / 1ps


module sprite_student_id (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit
);

    reg [15:0] sprite_x = 16'd1026;
    reg [15:0] sprite_y = 16'd10;
    wire sprite_hit_x, sprite_hit_y;
    wire [7:0] sprite_render_x;
    wire [7:0] sprite_render_y;

    parameter [0:1][2:0][7:0] palette_colors = {
        {8'h00, 8'h00, 8'h00},  // background
        {8'h00, 8'h00, 8'h00}  // black 
    };

    localparam [0:8][0:60][3:0] sprite_data = {
        {
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0
        },
        {
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0
        },
        {
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0
        },
        {
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0
        },
        {
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0
        },
        {
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0
        },
        {
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0
        },
        {
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0,
            4'd1,
            4'd1,
            4'd1,
            4'd0,
            4'd0
        },
        {
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0,
            4'd0
        }
    };

    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 4 * 61);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 4 * 9);
    assign sprite_render_x = (i_x - sprite_x) >> 2;
    assign sprite_render_y = (i_y - sprite_y) >> 2;

    wire [1:0] selected_palette;

    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];

    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);

endmodule
