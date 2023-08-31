`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 06:35:49 PM
// Design Name: 
// Module Name: substitute_Bytes
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


module substitute_bytes(
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
    
    wire [7:0] b [0:15];
    
    genvar i;
    generate
        for (i = 0; i<16; i = i+1) begin
            SBox S(
                .addr(a[i]),
                .dout(b[i])
            );
        end
    endgenerate
  
    reg [127 : 0] Q_reg, Q_next;
    always@(posedge clk, negedge reset_n)begin
        if(~reset_n) begin
            Q_reg <= Q_reg;
        end
        else begin
            Q_reg <= Q_next;
        end
    end
    
    always@(*)begin
        Q_next = Q_reg;
        if(~start)begin
            Q_next = 128'b0;
        end
        else begin
            Q_next = {b[0], b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8], b[9], b[10], b[11], b[12], b[13], b[14], b[15]};
        end
    end
    assign out = Q_reg;
endmodule
