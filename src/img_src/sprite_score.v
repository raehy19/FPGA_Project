`timescale 1ns / 1ps


module sprite_score (
    input wire [15:0] i_x,
    input wire [15:0] i_y,
    input wire i_v_sync,
    input wire i_scored,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue,
    output wire o_sprite_hit
);

    reg [15:0] sprite_x = 16'd660;
    reg [15:0] sprite_y = 16'd10;
    wire sprite_hit_x, sprite_hit_y;
    wire [8:0] sprite_render_x;
    wire [8:0] sprite_render_y;


    localparam [0:1][2:0][7:0] palette_colors = {
        {8'h00, 8'h00, 8'h00},  // background
        {8'h00, 8'h00, 8'h00}  // black
    };

    localparam [0:8][0:32][3:0] score = {
    {4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
    {4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0},
    {4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0},
    {4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
    {4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd0},
    {4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0},
    {4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd0,4'd0,4'd1,4'd0},
    {4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0,4'd1,4'd1,4'd1,4'd0,4'd0,4'd1,4'd0,4'd0,4'd0,4'd1,4'd0,4'd1,4'd1,4'd1,4'd1,4'd1,4'd0,4'd0,4'd0},
    {4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0,4'd0}
    };

    parameter [0:8][0:4][3:0] num_empty = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_zero = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_one = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_two = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd0, 4'd0, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_three = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd0, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_four = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd1, 4'd0, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_five = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_six = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_seven = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd1, 4'd1, 4'd1, 4'd1, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd1, 4'd0, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_eight = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //
    parameter [0:8][0:4][3:0] num_nine = {  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd1},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd1, 4'd0, 4'd0, 4'd0, 4'd1},  //
        {4'd0, 4'd1, 4'd1, 4'd1, 4'd0},  //
        {4'd0, 4'd0, 4'd0, 4'd0, 4'd0}  //
    };  //


    reg [0:8][0:4][3:0] units = num_zero;
    reg [0:8][0:4][3:0] tens = num_empty;


    assign sprite_hit_x = (i_x >= sprite_x) && (i_x < sprite_x + 4 * 44);
    assign sprite_hit_y = (i_y >= sprite_y) && (i_y < sprite_y + 36);
    assign sprite_render_x = (i_x - sprite_x) >> 2;
    assign sprite_render_y = (i_y - sprite_y) >> 2;

    wire [1:0] selected_palette;

    assign selected_palette = (sprite_render_x < 33) ? score[sprite_render_y][sprite_render_x] // text
        : (sprite_render_x == 38 ) ? 2'd0 // blank
        : ((sprite_render_x < 38) ? tens[sprite_render_y][sprite_render_x - 33] // tens
        : units[sprite_render_y][sprite_render_x - 39]); // units


    assign o_red = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][2] : 8'hXX;
    assign o_green = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][1] : 8'hXX;
    assign o_blue = (sprite_hit_x && sprite_hit_y) ? palette_colors[selected_palette][0] : 8'hXX;
    assign o_sprite_hit = ((sprite_hit_y & sprite_hit_x) && (selected_palette != 2'd0));

    integer temp_stored = 0;

    always @(posedge i_scored) begin
        case (units)   
            num_nine: begin
                case (tens)
                    num_eight: begin tens <= num_nine;  units <= num_zero;  end
                    num_seven: begin tens <= num_eight; units <= num_zero;  end
                    num_six:   begin tens <= num_seven; units <= num_zero;  end
                    num_five:  begin tens <= num_six;   units <= num_zero;  end
                    num_four:  begin tens <= num_five;  units <= num_zero;  end
                    num_three: begin tens <= num_four;  units <= num_zero;  end
                    num_two:   begin tens <= num_three; units <= num_zero;  end
                    num_one:   begin tens <= num_two;   units <= num_zero;  end
                    num_zero:  begin tens <= num_one;   units <= num_zero;  end
                    num_empty: begin tens <= num_one;   units <= num_zero;  end
                endcase
            end 
            num_eight: units <=num_nine;  
            num_seven: units <=num_eight; 
            num_six:   units <=num_seven; 
            num_five:  units <=num_six;    
            num_four:  units <=num_five;  
            num_three: units <=num_four;  
            num_two:   units <=num_three; 
            num_one:   units <=num_two;   
            num_zero:  units <=num_one;
        endcase
        temp_stored = 0;
        end
endmodule
