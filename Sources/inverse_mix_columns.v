`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2023 05:29:27 PM
// Design Name: 
// Module Name: inverse_mix_columns
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


module inverse_mix_columns(
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
    
    function [7:0] m02;
        input [7:0] x;
        begin
            if(x[7])
                m02 = (x<<1) ^ 8'h1B;
            else
                m02 = (x<<1);
        end
    endfunction
    
    function [7:0] m09;
        input [7:0] x;
        begin
            m09 = m02(m02(m02(x))) ^ x;
        end
    endfunction
        
    function [7:0] m0B;
        input [7:0] x;
        begin
            m0B = m02(m02(m02(x))) ^ m02(x) ^ x;
        end
    endfunction
    
    function [7:0] m0D;
        input [7:0] x;
        begin
            m0D = m02(m02(m02(x))) ^ m02(m02(x)) ^ x;
        end
    endfunction
    
    function [7:0] m0E;
        input [7:0] x;
        begin
            m0E = m02(m02(m02(x))) ^ m02(m02(x)) ^ m02(x);
        end
    endfunction
 
    wire [7:0] b [0:15];
    assign b[0] = m0E(a[0]) ^ m0B(a[1]) ^ m0D(a[2]) ^ m09(a[3]);
    assign b[1] = m09(a[0]) ^ m0E(a[1]) ^ m0B(a[2]) ^ m0D(a[3]);
    assign b[2] = m0D(a[0]) ^ m09(a[1]) ^ m0E(a[2]) ^ m0B(a[3]);
    assign b[3] = m0B(a[0]) ^ m0D(a[1]) ^ m09(a[2]) ^ m0E(a[3]);
    assign b[4] = m0E(a[4]) ^ m0B(a[5]) ^ m0D(a[6]) ^ m09(a[7]);
    assign b[5] = m09(a[4]) ^ m0E(a[5]) ^ m0B(a[6]) ^ m0D(a[7]);
    assign b[6] = m0D(a[4]) ^ m09(a[5]) ^ m0E(a[6]) ^ m0B(a[7]);
    assign b[7] = m0B(a[4]) ^ m0D(a[5]) ^ m09(a[6]) ^ m0E(a[7]);
    assign b[8] = m0E(a[8]) ^ m0B(a[9]) ^ m0D(a[10]) ^ m09(a[11]);
    assign b[9] = m09(a[8]) ^ m0E(a[9]) ^ m0B(a[10]) ^ m0D(a[11]);
    assign b[10]= m0D(a[8]) ^ m09(a[9]) ^ m0E(a[10]) ^ m0B(a[11]);
    assign b[11]= m0B(a[8]) ^ m0D(a[9]) ^ m09(a[10]) ^ m0E(a[11]);
    assign b[12] = m0E(a[12]) ^ m0B(a[13]) ^ m0D(a[14]) ^ m09(a[15]);
    assign b[13] = m09(a[12]) ^ m0E(a[13]) ^ m0B(a[14]) ^ m0D(a[15]);
    assign b[14] = m0D(a[12]) ^ m09(a[13]) ^ m0E(a[14]) ^ m0B(a[15]);
    assign b[15] = m0B(a[12]) ^ m0D(a[13]) ^ m09(a[14]) ^ m0E(a[15]);
    
    reg [127 : 0] Q_reg, Q_next;
    always@(posedge clk, negedge reset_n)begin
        if(~reset_n) begin
            Q_reg <= 127'b0;
        end
        else begin
            Q_reg <= Q_next;
        end    
    end
       
    always@(*)begin
        if(start) begin
            Q_next = {b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15]};
        end
        else begin
            Q_next = Q_reg;
        end
    end
    
    assign out = Q_reg;
endmodule
