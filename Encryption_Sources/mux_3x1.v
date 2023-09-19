`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 07:06:24 PM
// Design Name: 
// Module Name: mux_3x1
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


module mux_3x1(
    input [127 : 0] in1, in2, in3,
    input [1:0] sel,
    output reg [127 : 0] mux_out
    );
    
    always@(*)begin
        mux_out = 128'b0;
        case(sel)
            2'b00: mux_out = in1;
            2'b01: mux_out = in2;
            2'b10: mux_out = in3;
            default: mux_out = 128'b0;
        endcase
    end
endmodule

