`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2023 11:32:33 PM
// Design Name: 
// Module Name: inverse_key_expansion_top
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


module inverse_key_expansion_top(
    input start,
    input [127 : 0] key,
    output [1407 : 0] out
    );
    
    wire [127 : 0] ke1_out, ke2_out, ke3_out, ke4_out, ke5_out, ke6_out, ke7_out, ke8_out, ke9_out, ke10_out;
    
    inverse_key_expansion key1(
        .RC(32'h01_00_00_00),
        .in(key),
        .out(ke1_out)
    );
    
    inverse_key_expansion key2(
        .RC(32'h02_00_00_00),
        .in(ke1_out),
        .out(ke2_out)
    );
    
    inverse_key_expansion key3(
        .RC(32'h04_00_00_00),
        .in(ke2_out),
        .out(ke3_out)
    );
    
    inverse_key_expansion key4(
        .RC(32'h08_00_00_00),
        .in(ke3_out),
        .out(ke4_out)
    );
    
    inverse_key_expansion key5(
        .RC(32'h10_00_00_00),
        .in(ke4_out),
        .out(ke5_out)
    );
    
    inverse_key_expansion key6(
        .RC(32'h20_00_00_00),
        .in(ke5_out),
        .out(ke6_out)
    );
    
    inverse_key_expansion key7(
        .RC(32'h40_00_00_00),
        .in(ke6_out),
        .out(ke7_out)
    );
    
    inverse_key_expansion key8(
        .RC(32'h80_00_00_00),
        .in(ke7_out),
        .out(ke8_out)
    );
    
    inverse_key_expansion key9(
        .RC(32'h1B_00_00_00),
        .in(ke8_out),
        .out(ke9_out)
    );
    
    inverse_key_expansion key10(
        .RC(32'h36_00_00_00),
        .in(ke9_out),
        .out(ke10_out)
    );
    
    assign out = start?{key ,ke1_out, ke2_out, ke3_out, ke4_out, ke5_out, ke6_out, ke7_out, ke8_out, ke9_out, ke10_out} : 1408'b0;
endmodule