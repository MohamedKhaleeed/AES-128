`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/01/2023 01:45:19 AM
// Design Name: 
// Module Name: mux_11x1
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


module mux_11x1(
    input [127 : 0] in0, in1, in2, in3, in4, in5, in6, in7, in8, in9, in10,
    input [3 : 0] sel,
    output reg [127 : 0] mux_out
    );
    
    always@(*)begin
        mux_out = 128'b0;
        case(sel)
            4'd0: mux_out = in0;
            4'd1: mux_out = in1;
            4'd2: mux_out = in2;
            4'd3: mux_out = in3;
            4'd4: mux_out = in4;
            4'd5: mux_out = in5;
            4'd6: mux_out = in6;
            4'd7: mux_out = in7;
            4'd8: mux_out = in8;
            4'd9: mux_out = in9;
            4'd10: mux_out = in10;
            default: mux_out = 128'b0;
        endcase
    end
endmodule
