`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/30/2023 06:53:56 PM
// Design Name: 
// Module Name: add_round_key
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


module add_round_key(
    input clk, reset_n, start,
    input [127 : 0] data, key,
    output [127 : 0] ark_out
    );
    
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
            Q_next = key ^ data;
        end
    end
    
    assign ark_out = Q_reg; 
endmodule