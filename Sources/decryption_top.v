`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2023 12:16:38 AM
// Design Name: 
// Module Name: decryption_top
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


module decryption_top(
    input clk, reset_n, start,
    input [127 : 0] ciphertext, key,
    output [127 : 0] plaintext,
    output done
    );
    
    wire mux1_sel, counter_done;
    wire add_start, mix_start, shift_start, sub_start;
    wire [3:0] mux2_sel;
    decryption_counter counter(
        .clk(clk),
        .reset_n(reset_n),
        .start(start),
        .add_start(add_start),
        .mix_start(mix_start),
        .shift_start(shift_start),
        .sub_start(sub_start),
        .mux1_sel(mux1_sel),
        .mux2_sel(mux2_sel),
        .counter_done(counter_done)
    );
    
    wire [127:0] inv_shift_out ,inv_mix_out, mux2_out, add_out, inv_sub_out;
    wire [1407 : 0] ex_key;
    mux_11x1 mux(
        .in0(ex_key[127:0]),
        .in1(ex_key[255:128]),
        .in2(ex_key[383:256]),
        .in3(ex_key[511:384]),
        .in4(ex_key[639:512]),
        .in5(ex_key[767:640]),
        .in6(ex_key[895:768]),
        .in7(ex_key[1023:896]),
        .in8(ex_key[1151:1024]),
        .in9(ex_key[1279:1152]),
        .in10(ex_key[1407:1280]),
        .sel(mux2_sel),
        .mux_out(mux2_out)
    );
    
    inverse_shift_row inv_shift(
        .clk(clk),
        .reset_n(reset_n),
        .start(shift_start),
        .in(mux1_sel? inv_mix_out : add_out),
        .out(inv_shift_out)
    );
    
    inverse_substitute_bytes inv_sub(
        .clk(clk),
        .reset_n(reset_n),
        .start(sub_start),
        .in(inv_shift_out),
        .out(inv_sub_out)
    );
    
    add_round_key add(
        .clk(clk),
        .reset_n(reset_n),
        .start(add_start),
        .data(mux1_sel? inv_sub_out : ciphertext),
        .key(mux2_out),
        .ark_out(add_out)
    );
    
    inverse_mix_columns inv_mix(
        .clk(clk),
        .reset_n(reset_n),
        .start(mix_start),
        .in(add_out),
        .out(inv_mix_out)
    );
    
    inverse_key_expansion_top ke(
        .start(start),
        .key(key),
        .out(ex_key)
    );
    
    reg_file ff(
        .clk(clk),
        .reset_n(reset_n),
        .start(counter_done),
        .in(add_out),
        .done(done),
        .out(plaintext)
    );
endmodule
