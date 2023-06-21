`timescale 1ns / 1ps


module sprite_life (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire i_crushed,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit,
    output reg o_is_dead = 0
);

    reg [15:0] sprite_x = 16'd360;
    reg [15:0] sprite_y = 16'd10;
    reg [15:0] sprite_fx = 16'd400;
    reg [15:0] sprite_fy = 16'd280;
    wire sprite_hit_x, sprite_hit_y;
    wire sprite_hit_fx, sprite_hit_fy;
    wire [7:0] sprite_render_x;
    wire [7:0] sprite_render_y;
    wire [7:0] sprite_render_fx;
    wire [7:0] sprite_render_fy;


    localparam [0:2][2:0][7:0] palette_colors = {
        {8'h00, 8'h00, 8'h00},  // background
        {8'h00, 8'h00, 8'h00},  // black
        {8'hF0, 8'h56, 8'h50}  // red
    };

    localparam [0:8][0:19][3:0] life = {
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1},
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0}
    };

    parameter [0:8][0:8][3:0] empty_heart = {
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd1, 4'd0, 4'd1, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0},
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0}
    };

    parameter [0:8][0:8][3:0] filled_heart = {
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd1, 4'd0, 4'd1, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd2, 4'd2, 4'd1, 4'd2, 4'd2, 4'd1, 4'd0},
        {4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0},
        {4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0},
        {4'd0, 4'd0, 4'd1, 4'd2, 4'd2, 4'd2, 4'd1, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd2, 4'd1, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0}
    };

    localparam [0:8][0:30][3:0] retry = {
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd1, 4'd1, 4'd1, 4'd1, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0, 4'd1, 4'd0, 4'd0, 4'd0},
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0, 4'd0}
    };

    reg [0:8][0:8][3:0] heart_1 = filled_heart;
    reg [0:8][0:8][3:0] heart_2 = filled_heart;
    reg [0:8][0:8][3:0] heart_3 = filled_heart;

    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 4 * 48);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 36);
    assign sprite_render_x = (i_x - sprite_x) >> 2;
    assign sprite_render_y = (i_y - sprite_y) >> 2;

    wire [1:0] selected_palette;

    assign selected_palette = (sprite_render_x < 21) ? life[sprite_render_y][sprite_render_x]  // text
        : ((sprite_render_x < 30) ? heart_1[sprite_render_y][sprite_render_x-21]  // heart_1
        : ((sprite_render_x < 39) ? heart_2[sprite_render_y][sprite_render_x-30]  // heart_2
        : heart_3[sprite_render_y][sprite_render_x-39]));  // heart_3

    assign sprite_hit_fx = (i_x >= sprite_fx) && (i_x < sprite_fx + 16 * 31);
    assign sprite_hit_fy = (i_y >= sprite_fy) && (i_y < sprite_fy + 16 * 9);
    assign sprite_render_fx = (i_x - sprite_fx) >> 4;
    assign sprite_render_fy = (i_y - sprite_fy) >> 4;

    wire [1:0] selected_palette_f;

    assign selected_palette_f = o_is_dead? retry[sprite_render_fy][sprite_render_fx] : 2'd0;

    assign o_red    = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : ((sprite_hit_fx && sprite_hit_fy)? palette_colors[selected_palette_f][2]: 8'hXX);
    assign o_green  = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : ((sprite_hit_fx && sprite_hit_fy)? palette_colors[selected_palette_f][1]: 8'hXX);
    assign o_blue   = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : ((sprite_hit_fx && sprite_hit_fy)? palette_colors[selected_palette_f][0]: 8'hXX);
    assign o_sprite_hit = ((sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0))  || ((sprite_hit_fx && sprite_hit_fy) && (selected_palette_f != 2'd0));

    always @(posedge i_crushed) begin
        if (heart_3 == filled_heart) heart_3 <= empty_heart;
        else if (heart_3 == filled_heart) heart_3 <= empty_heart;
        else if (heart_2 == filled_heart) heart_2 <= empty_heart;
        else begin
            heart_1   <= empty_heart;
            o_is_dead <= 1;
        end
    end

endmodule
