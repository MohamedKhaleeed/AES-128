`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2023 11:43:23 PM
// Design Name: 
// Module Name: decryption_counter
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


module decryption_counter(
    input clk, reset_n, start,
    output add_start, mix_start, shift_start, sub_start,
    output [3 : 0] mux2_sel,
    output mux1_sel,counter_done
    );
    localparam [2 : 0] idle = 3'b000;
    localparam [2 : 0] add = 3'b001;
    localparam [2 : 0] inv_sub = 3'b010;
    localparam [2 : 0] inv_shift = 3'b011;
    localparam [2 : 0] inv_mix = 3'b100;
    localparam [2 : 0] key = 3'b101;
    
    reg add_reg, add_next, mix_reg, mix_next, shift_reg, shift_next, sub_reg, sub_next;
    reg mux1_reg, mux1_next, done_reg, done_next;
    reg [3 : 0] mux2_reg, mux2_next;
    reg [3 : 0] C_reg, C_next;
    reg [2 : 0] next_state, curr_state;
    always@(posedge clk, negedge reset_n)begin
        if(~reset_n)begin
            curr_state <= 3'b0;
            C_reg <= 4'b0;
            add_reg <= 1'b0;
            mix_reg <= 1'b0;
            shift_reg <= 1'b0;
            sub_reg <= 1'b0;
            mux1_reg <= 1'b0;
            mux2_reg <= 4'b0;
            done_reg <= 1'b0;
        end
        else begin
            curr_state <= next_state;
            C_reg <= C_next;
            add_reg <= add_next;
            mix_reg <= mix_next;
            shift_reg <= shift_next;
            sub_reg <= sub_next;
            mux1_reg <= mux1_next;
            mux2_reg <= mux2_next;
            done_reg <= done_next;
        end
    end
    
    always@(*)begin
        next_state = curr_state;
        C_next = C_reg;
        add_next = 1'b0;
        mix_next = 1'b0;
        sub_next = 1'b0;
        shift_next = 1'b0;
        mux1_next = 1'b1;
        mux2_next = 4'b0;
        done_next = 1'b0;
        
        case(C_reg)
            4'd0 : begin
                mux1_next = 1'b0;
                mux2_next = 4'd0;
            end
            4'd1 : mux2_next = 4'd1;
            4'd2 : mux2_next = 4'd2;
            4'd3 : mux2_next = 4'd3;
            4'd4 : mux2_next = 4'd4;
            4'd5 : mux2_next = 4'd5;
            4'd6 : mux2_next = 4'd6;
            4'd7 : mux2_next = 4'd7;
            4'd8 : mux2_next = 4'd8;
            4'd9 : mux2_next = 4'd9;
            4'd10 : mux2_next = 4'd10;
            default : begin
                mux1_next = 1'b1;
                mux2_next = 4'b0;
                done_next = 1'b0;
            end
        endcase
  
        case(curr_state)
            idle: begin
                if(start)
                    next_state = key;
                else
                    next_state = idle;
            end
            
            key: begin;
                next_state = add;
            end
            
            inv_shift: begin
                shift_next = 1'b1;
                next_state = inv_sub;
            end
            
            inv_sub: begin
                C_next = C_reg + 1;
                sub_next = 1'b1;
                next_state = add;
            end
            
            add: begin
                add_next = 1'b1;
                if(C_reg == 4'b0000)
                    next_state = inv_shift;
                else
                    next_state = inv_mix;
            end
            
            inv_mix: begin
                mix_next = 1'b1;
                next_state = inv_shift;
                if(C_reg == 4'd10)
                    done_next = 1'b1;
            end
      
            default: begin
                next_state = curr_state;
                C_next = C_reg;
                add_next = 1'b0;
                mix_next = 1'b0;
                sub_next = 1'b0;
                shift_next = 1'b0;
                mux1_next = 1'b1;
                mux2_next = 2'b01;
                done_next = 1'b0;
            end
        endcase
    end
    
        assign add_start = add_reg;
        assign mix_start = mix_reg;
        assign shift_start = shift_reg;
        assign sub_start = sub_reg;
        assign mux1_sel = mux1_reg; 
        assign mux2_sel = mux2_reg; 
        assign counter_done = done_reg; 
endmodule

