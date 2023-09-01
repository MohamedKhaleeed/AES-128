`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2023 02:17:10 AM
// Design Name: 
// Module Name: decryption_tb
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


module decryption_tb();
    reg clk, reset_n, start;
    reg [127: 0] ciphertext, key;
    wire [127: 0] plaintext;
    wire done;
    
    decryption_top dut(
        .clk(clk),
        .start(start),
        .reset_n(reset_n),
        .key(key),
        .plaintext(plaintext),
        .ciphertext(ciphertext),
        .done(done)
    );
    
    localparam T = 10;
    always begin
        clk = 1'b0;
        #(T/2)
        clk = 1'b1;
        #(T/2);
    end
    
    initial begin
        reset_n = 0;
        start = 0;
        #3
        reset_n = 1;
        #3
        key = 128'hDF69A7E1_05D8963B_1685FFCC_EE3369FA;
        ciphertext = 128'h029795d9_d0d6129e_96f5c12f_fe23e5d0;
        start = 1;
        #600;
        $finish;
    end
endmodule
