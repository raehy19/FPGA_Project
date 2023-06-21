`timescale 1ns / 1ps


module sprite_coin_center (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire [15:0] i_penguin_x,
    input wire i_is_finished,
    input wire i_is_dead,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit,
    output reg o_scored
);


    reg [15:0] sprite_x = 16'd640 - 16'd16;
    reg [15:0] sprite_y = 16'd720 - 128;
    wire sprite_hit_x, sprite_hit_y;
    wire [7:0] sprite_render_x;
    wire [7:0] sprite_render_y;


    parameter [0:2][2:0][7:0] palette_colors = {
        {8'h00, 8'h00, 8'h00},  // background
        {8'hff, 8'hdb, 8'h00},  // yellow (border)
        {8'hff, 8'hf2, 8'ha5}  // yellow (fill)
    };

    localparam [0:31][0:31][3:0] sprite_data = {
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0}
    };


    assign sprite_hit_x = (sprite_y < 300) ? (i_x >= sprite_x) && (i_x < sprite_x + 32)  // x1
        : (sprite_y < 450) ? (i_x >= sprite_x) && (i_x < sprite_x + 64)  // x2
        : (i_x >= sprite_x) && (i_x < sprite_x + 128);  // x4

    assign sprite_hit_y = (sprite_y < 300) ? (i_y >= sprite_y) && (i_y < sprite_y + 32)  // x1
        : (sprite_y < 450) ? (i_y >= sprite_y) && (i_y < sprite_y + 64)  // x2
        : (i_y >= sprite_y) && (i_y < sprite_y + 128);  // x4

    assign sprite_render_x = (sprite_y < 300) ? (i_x - sprite_x)  // x1
        : (sprite_y < 450) ? (i_x - sprite_x) >> 1  // x2
        : (i_x - sprite_x) >> 2;  // x4

    assign sprite_render_y = (sprite_y < 300) ? (i_y - sprite_y)  // x1
        : (sprite_y < 450) ? (i_y - sprite_y) >> 1  // x2
        : (i_y - sprite_y) >> 2;  // x4

    assign o_scored = (sprite_y > 540 && sprite_y < 550 && i_penguin_x == 16'd640 - 16'd64);

    wire [1:0] selected_palette;

    assign selected_palette = sprite_data[sprite_render_y][sprite_render_x];

    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = (sprite_y >= 160 - 16 && sprite_y < 720 - 128) && (sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0);

    integer delay = 0;

    always @(posedge i_v_sync) begin
        if (i_is_finished == 0 && i_is_dead == 0) begin
            if (o_scored) begin
                sprite_y <= 1000;
            end
            if (sprite_y >= 720 - 128) begin
                ++delay;
                if (delay > 1000) begin
                    sprite_y <= 0;
                    delay <= 0;
                end
            end else begin
                sprite_y <= sprite_y + 1;
            end
            sprite_x = (sprite_y <= 300) ? 16'd640 - 16'd16  // x1
            : (sprite_y <= 450) ? 16'd640 - 16'd32  // x2
            : 16'd640 - 16'd64;  // x4
        end
    end

endmodule
