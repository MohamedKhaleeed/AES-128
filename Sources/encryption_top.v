`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 07:02:21 PM
// Design Name: 
// Module Name: encryption_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module encryption_top(
    input clk, reset_n, start,
    input [127 : 0] plaintext, key,
    output [127 : 0] ciphertext,
    output done
    );
    
    wire mux1_sel, counter_done;
    wire add_start, mix_start, shift_start, sub_start, key_start;
    wire [1:0] mux2_sel;
    wire [31:0] key_RC;
    counter fsm(
        .clk(clk),
        .reset_n(reset_n),
        .start(start),
        .add_start(add_start),
        .mix_start(mix_start),
        .shift_start(shift_start),
        .sub_start(sub_start),
        .key_start(key_start),
        .mux1_sel(mux1_sel),
        .mux2_sel(mux2_sel),
        .key_RC(key_RC),
        .counter_done(counter_done)
    );
    
    wire [127:0] shift_out ,mix_out, mux3_out, ark_out, sub_out, ex_key;
    mux_3x1 mux(
        .in1(plaintext),
        .in2(mix_out),
        .in3(shift_out),
        .sel(mux2_sel),
        .mux_out(mux3_out)
    );
    
    add_round_key add(
        .clk(clk),
        .reset_n(reset_n),
        .start(add_start),
        .data(mux3_out),
        .key(mux1_sel? ex_key : key),
        .ark_out(ark_out)
    );
    
    substitute_bytes sub(
        .clk(clk),
        .reset_n(reset_n),
        .start(sub_start),
        .in(ark_out),
        .out(sub_out)
    );
    
    shift_row shift(
        .clk(clk),
        .reset_n(reset_n),
        .start(shift_start),
        .in(sub_out),
        .out(shift_out)
    );
    
    mix_columns mix(
        .clk(clk),
        .reset_n(reset_n),
        .start(mix_start),
        .in(shift_out),
        .out(mix_out)
    );
    
    key_expansion ke(
        .clk(clk),
        .reset_n(reset_n),
        .start(key_start),
        .RC(key_RC),
        .in(mux1_sel? ex_key : key),
        .out(ex_key)
    );
    
    reg_file ff(
        .clk(clk),
        .reset_n(reset_n),
        .start(counter_done),
        .in(ark_out),
        .done(done),
        .out(ciphertext)
    );
endmodule