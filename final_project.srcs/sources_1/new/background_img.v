`timescale 1ns / 1ps


module background_img #(
    H_RES = 1280,
    V_RES = 720
) (
    input wire signed [15:0] i_x,
    input wire signed [15:0] i_y,
    output wire [7:0] o_red,
    output wire [7:0] o_green,
    output wire [7:0] o_blue
);


    assign o_red = (i_y < 160) ? 8'h53 :  // sky
        ((8 * i_y < -9 * i_x + 5760) || (8 * i_y < 9 * i_x - 5760)) ? 8'h0f  // ocean
        : 8'h99;  // road
    assign o_green = (i_y < 160) ? 8'h8a :  // sky
        ((8 * i_y < -9 * i_x + 5760) || (8 * i_y < 9 * i_x - 5760)) ? 8'h11  // ocean
        : 8'hAF;  // road
    assign o_blue = (i_y < 160) ? 8'hc6 :  // sky
        ((8 * i_y < -9 * i_x + 5760) || (8 * i_y < 9 * i_x - 5760)) ? 8'h59  // ocean
        : 8'hCA;  // road

endmodule
