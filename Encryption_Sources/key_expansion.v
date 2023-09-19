`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 06:57:37 PM
// Design Name: 
// Module Name: key_expansion
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


module key_expansion(
    input clk, reset_n, start,
    input [31 : 0] RC,
    input [127 : 0] in,
    output [127 : 0] out
    );
    
    wire [7:0] k [0:15];
    assign k[0] = in[127:120];
    assign k[1] = in[119:112];
    assign k[2] = in[111:104];
    assign k[3] = in[103:96];
    assign k[4] = in[95:88];
    assign k[5] = in[87:80];
    assign k[6] = in[79:72];
    assign k[7] = in[71:64];
    assign k[8] = in[63:56];
    assign k[9] = in[55:48];
    assign k[10] = in[47:40];
    assign k[11] = in[39:32];
    assign k[12] = in[31:24];
    assign k[13] = in[23:16];
    assign k[14] = in[15:8];
    assign k[15] = in[7:0];
    
    wire [31:0] w_in [0:3];
    assign w_in[0] = {k[0], k[1], k[2], k[3]};
    assign w_in[1] = {k[4], k[5], k[6], k[7]};
    assign w_in[2] = {k[8], k[9], k[10], k[11]};
    assign w_in[3] = {k[12], k[13], k[14], k[15]};
    
    wire [7:0] b [0:3];
    
    genvar i;
    generate
        for (i = 12; i<16; i = i+1) begin
            SBox S(
                .addr(k[i]),
                .dout(b[i-12])
            );
        end
    endgenerate
 
    wire [31:0] g; 
    assign g = {b[1], b[2], b[3], b[0]} ^ RC;
    
    wire [31:0] w_out [0:3];
    assign w_out[0] = w_in[0] ^ g;
    assign w_out[1] = w_in[1] ^ w_out[0];
    assign w_out[2] = w_in[2] ^ w_out[1];
    assign w_out[3] = w_in[3] ^ w_out[2];
    
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
            Q_next = {w_out[0], w_out[1], w_out[2], w_out[3]};
        end
    end
    
    assign out = Q_reg;
endmodule