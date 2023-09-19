`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2023 04:56:04 AM
// Design Name: 
// Module Name: reg_file
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


module reg_file(
    input clk, reset_n, start,
    input [127 : 0] in,
    output done,
    output [127 : 0] out
    );
    
    reg D_reg, D_next;
    reg [127 : 0] Q_reg, Q_next;
    always@(posedge clk, negedge reset_n)begin
        if(~reset_n) begin
            Q_reg <= 128'b0;
            D_reg <= 1'b0;
        end
        else begin
            Q_reg <= Q_next;
            D_reg <= D_next;
        end
    end
    
    always@(*)begin
        Q_next = Q_reg;
        D_next = D_reg;
        if(~start)begin
            Q_next = Q_reg;
            D_next = D_reg;
        end
        else begin
            Q_next = in;
            D_next = 1'b1;
        end
    end
    
    assign out = Q_reg;
    assign done = D_reg;
endmodule
