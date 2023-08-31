`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 06:56:14 PM
// Design Name: 
// Module Name: mix_columns
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


module mix_columns(
    input clk, reset_n, start,
    input [127 : 0] in,
    output [127 : 0] out
    );
    
    wire [7:0] a [0:15];
    assign a[0] = in[127:120];
    assign a[1] = in[119:112];
    assign a[2] = in[111:104];
    assign a[3] = in[103:96];
    assign a[4] = in[95:88];
    assign a[5] = in[87:80];
    assign a[6] = in[79:72];
    assign a[7] = in[71:64];
    assign a[8] = in[63:56];
    assign a[9] = in[55:48];
    assign a[10] = in[47:40];
    assign a[11] = in[39:32];
    assign a[12] = in[31:24];
    assign a[13] = in[23:16];
    assign a[14] = in[15:8];
    assign a[15] = in[7:0];
    
    wire [7:0] m [0:15];
    assign m[0] = 8'h02;
    assign m[1] = 8'h01;
    assign m[2] = 8'h01;
    assign m[3] = 8'h03;
    assign m[4] = 8'h03;
    assign m[5] = 8'h02;
    assign m[6] = 8'h01;
    assign m[7] = 8'h01;
    assign m[8] = 8'h01;
    assign m[9] = 8'h03;
    assign m[10] = 8'h02;
    assign m[11] = 8'h01;
    assign m[12] = 8'h01;
    assign m[13] = 8'h01;
    assign m[14] = 8'h03;
    assign m[15] = 8'h02;
    
    function [7:0] mix_column;
        input [7:0] y,x;
        begin
        case(y)
            8'h01: mix_column = x;
            8'h02: if(x[7])
                    mix_column = (x<<1) ^ 8'h1B;
                   else
                    mix_column = (x<<1);
            8'h03: if(x[7])
                    mix_column = (x<<1) ^ 8'h1B ^ x;
                   else
                    mix_column = (x<<1) ^ x;
            default: mix_column = 8'b0;
        endcase
        end
    endfunction
    
    wire [7:0] b [0:15];
    assign b[0] = mix_column(m[0], a[0]) ^ mix_column(m[4], a[1]) ^ mix_column(m[8], a[2]) ^ mix_column(m[12], a[3]);
    assign b[1] = mix_column(m[1], a[0]) ^ mix_column(m[5], a[1]) ^ mix_column(m[9], a[2]) ^ mix_column(m[13], a[3]);
    assign b[2] = mix_column(m[2], a[0]) ^ mix_column(m[6], a[1]) ^ mix_column(m[10], a[2]) ^ mix_column(m[14], a[3]);
    assign b[3] = mix_column(m[3], a[0]) ^ mix_column(m[7], a[1]) ^ mix_column(m[11], a[2]) ^ mix_column(m[15], a[3]);
    assign b[4] = mix_column(m[0], a[4]) ^ mix_column(m[4], a[5]) ^ mix_column(m[8], a[6]) ^ mix_column(m[12], a[7]);
    assign b[5] = mix_column(m[1], a[4]) ^ mix_column(m[5], a[5]) ^ mix_column(m[9], a[6]) ^ mix_column(m[13], a[7]);
    assign b[6] = mix_column(m[2], a[4]) ^ mix_column(m[6], a[5]) ^ mix_column(m[10], a[6]) ^ mix_column(m[14], a[7]);
    assign b[7] = mix_column(m[3], a[4]) ^ mix_column(m[7], a[5]) ^ mix_column(m[11], a[6]) ^ mix_column(m[15], a[7]);
    assign b[8] = mix_column(m[0], a[8]) ^ mix_column(m[4], a[9]) ^ mix_column(m[8], a[10]) ^ mix_column(m[12], a[11]);
    assign b[9] = mix_column(m[1], a[8]) ^ mix_column(m[5], a[9]) ^ mix_column(m[9], a[10]) ^ mix_column(m[13], a[11]);
    assign b[10] = mix_column(m[2], a[8]) ^ mix_column(m[6], a[9]) ^ mix_column(m[10], a[10]) ^ mix_column(m[14], a[11]);
    assign b[11] = mix_column(m[3], a[8]) ^ mix_column(m[7], a[9]) ^ mix_column(m[11], a[10]) ^ mix_column(m[15], a[11]);
    assign b[12] = mix_column(m[0], a[12]) ^ mix_column(m[4], a[13]) ^ mix_column(m[8], a[14]) ^ mix_column(m[12], a[15]);
    assign b[13] = mix_column(m[1], a[12]) ^ mix_column(m[5], a[13]) ^ mix_column(m[9], a[14]) ^ mix_column(m[13], a[15]);
    assign b[14] = mix_column(m[2], a[12]) ^ mix_column(m[6], a[13]) ^ mix_column(m[10], a[14]) ^ mix_column(m[14], a[15]);
    assign b[15] = mix_column(m[3], a[12]) ^ mix_column(m[7], a[13]) ^ mix_column(m[11], a[14]) ^ mix_column(m[15], a[15]);
    
    reg [127 : 0] Q_reg, Q_next;
    always@(posedge clk, negedge reset_n)begin
        if(~reset_n) begin
            Q_reg <= 128'b0;
        end
        else begin
            Q_reg <= Q_next;
        end
    end
    
    always@(*)begin
        Q_next = Q_reg;
        if(~start)begin
            Q_next = Q_reg;
        end
        else begin
            Q_next = {b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15]};
        end
    end
    
    assign out = Q_reg;
endmodule