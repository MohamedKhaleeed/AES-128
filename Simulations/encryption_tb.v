`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 07:52:50 PM
// Design Name: 
// Module Name: encryption_tb
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


module encryption_tb();
    reg clk, reset_n, start;
    reg [127: 0] plaintext, key;
    wire [127: 0] ciphertext;
    wire done;
    
    encryption_top dut(
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
        plaintext = 128'h5478DFCA_CC9634FC_C56CA5DD_E66600FF;
        start = 1;
        #600;
        $finish;
    end
endmodule
