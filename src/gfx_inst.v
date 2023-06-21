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
    wire [7:0] distance_red, distance_green, distance_blue;
    wire [7:0] life_red, life_green, life_blue;
    wire [7:0] score_red, score_green, score_blue;
    wire [7:0] student_id_red, student_id_green, student_id_blue;
    wire [7:0] glacier1_red, glacier1_green, glacier1_blue;
    wire [7:0] glacier2_red, glacier2_green, glacier2_blue;
    wire [7:0] coin_center_red, coin_center_green, coin_center_blue;
    wire [7:0] coin_right_red, coin_right_green, coin_right_blue;
    wire [7:0] coin_left_red, coin_left_green, coin_left_blue;
    wire [7:0] obstacle_center_red, obstacle_center_green, obstacle_center_blue;
    wire [7:0] obstacle_right_red, obstacle_right_green, obstacle_right_blue;
    wire [7:0] obstacle_left_red, obstacle_left_green, obstacle_left_blue;
    wire [7:0] penguin_red, penguin_green, penguin_blue;
    wire distance_hit, life_hit, score_hit, student_id_hit;
    wire glacier1_hit, glacier2_hit;
    wire coin_center_hit, coin_right_hit, coin_left_hit;
    wire obstacle_center_hit, obstacle_right_hit, obstacle_left_hit;
    wire penguin_hit;


    wire [1:0] game_state;  // 0 : playing, 1 : dead, 2 : finished
    wire [15:0] penguin_x;
    wire scored, scored1, scored2, scored3;
    assign scored = scored1 | scored2 | scored3;
    wire crushed, crushed1, crushed2, crushed3;
    assign crushed = crushed1 | crushed2 | crushed3;

    background_img bgimg (
        .i_x    (i_x),
        .i_y    (i_y),
        .o_red  (bg_red),
        .o_green(bg_green),
        .o_blue (bg_blue)
    );

    sprite_distance distance (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (distance_red),
        .o_green     (distance_green),
        .o_blue      (distance_blue),
        .o_sprite_hit(distance_hit)
    );

    sprite_life life (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (life_red),
        .o_green     (life_green),
        .o_blue      (life_blue),
        .o_sprite_hit(life_hit)
    );

    sprite_score score (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .i_scored    (scored),
        .o_red       (score_red),
        .o_green     (score_green),
        .o_blue      (score_blue),
        .o_sprite_hit(score_hit)
    );

    sprite_student_id student_id (
        .i_x         (i_x),
        .i_y         (i_y),
        .o_red       (student_id_red),
        .o_green     (student_id_green),
        .o_blue      (student_id_blue),
        .o_sprite_hit(student_id_hit)
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
        .i_scored    (scored),
        .o_red       (penguin_red),
        .o_green     (penguin_green),
        .o_blue      (penguin_blue),
        .o_sprite_hit(penguin_hit),
        .o_penguin_x (penguin_x)
    );

    sprite_coin_center coin_center (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .i_penguin_x (penguin_x),
        .o_red       (coin_center_red),
        .o_green     (coin_center_green),
        .o_blue      (coin_center_blue),
        .o_sprite_hit(coin_center_hit),
        .o_scored    (scored1)
    );

    sprite_coin_right coin_right (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .i_penguin_x (penguin_x),
        .o_red       (coin_right_red),
        .o_green     (coin_right_green),
        .o_blue      (coin_right_blue),
        .o_sprite_hit(coin_right_hit),
        .o_scored    (scored2)
    );

    sprite_coin_left coin_left (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .i_penguin_x (penguin_x),
        .o_red       (coin_left_red),
        .o_green     (coin_left_green),
        .o_blue      (coin_left_blue),
        .o_sprite_hit(coin_left_hit),
        .o_scored    (scored3)
    );

    sprite_obstacle_center obstacle_center (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (obstacle_center_red),
        .o_green     (obstacle_center_green),
        .o_blue      (obstacle_center_blue),
        .o_sprite_hit(obstacle_center_hit)
    );

    sprite_obstacle_right obstacle_right (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (obstacle_right_red),
        .o_green     (obstacle_right_green),
        .o_blue      (obstacle_right_blue),
        .o_sprite_hit(obstacle_right_hit)
    );

    sprite_obstacle_left obstacle_left (
        .i_x         (i_x),
        .i_y         (i_y),
        .i_v_sync    (i_v_sync),
        .o_red       (obstacle_left_red),
        .o_green     (obstacle_left_green),
        .o_blue      (obstacle_left_blue),
        .o_sprite_hit(obstacle_left_hit)
    );

    always @(*) begin
        if (distance_hit == 1) begin
            o_red   = distance_red;
            o_green = distance_green;
            o_blue  = distance_blue;
        end else if (life_hit == 1) begin
            o_red   = life_red;
            o_green = life_green;
            o_blue  = life_blue;
        end else if (score_hit == 1) begin
            o_red   = score_red;
            o_green = score_green;
            o_blue  = score_blue;
        end else if (student_id_hit == 1) begin
            o_red   = student_id_red;
            o_green = student_id_green;
            o_blue  = student_id_blue;
        end else if (glacier1_hit == 1) begin
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
        end else if (coin_center_hit == 1) begin
            o_red   = coin_center_red;
            o_green = coin_center_green;
            o_blue  = coin_center_blue;
        end else if (coin_right_hit == 1) begin
            o_red   = coin_right_red;
            o_green = coin_right_green;
            o_blue  = coin_right_blue;
        end else if (coin_left_hit == 1) begin
            o_red   = coin_left_red;
            o_green = coin_left_green;
            o_blue  = coin_left_blue;
        end else if (obstacle_center_hit == 1) begin
            o_red   = obstacle_center_red;
            o_green = obstacle_center_green;
            o_blue  = obstacle_center_blue;
        end else if (obstacle_right_hit == 1) begin
            o_red   = obstacle_right_red;
            o_green = obstacle_right_green;
            o_blue  = obstacle_right_blue;
        end else if (obstacle_left_hit == 1) begin
            o_red   = obstacle_left_red;
            o_green = obstacle_left_green;
            o_blue  = obstacle_left_blue;
        end else begin
            o_red   = bg_red;
            o_green = bg_green;
            o_blue  = bg_blue;
        end
    end

endmodule
