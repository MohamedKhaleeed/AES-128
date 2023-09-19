`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/31/2023 11:45:08 PM
// Design Name: 
// Module Name: encryption_counter
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


module encryption_counter(
    input clk, reset_n, start,
    output add_start, mix_start, shift_start, sub_start, key_start,
    output [1:0] mux2_sel,
    output [31:0] key_RC,
    output mux1_sel,counter_done
    );
    localparam [2 : 0] idle = 3'b000;
    localparam [2 : 0] add = 3'b001;
    localparam [2 : 0] sub = 3'b010;
    localparam [2 : 0] shift = 3'b011;
    localparam [2 : 0] mix = 3'b100;
    localparam [2 : 0] key = 3'b101;
    
    reg [31 : 0] RC_reg, RC_next;
    reg add_reg, add_next, mix_reg, mix_next, shift_reg, shift_next, sub_reg, sub_next, key_reg, key_next;
    reg mux1_reg, mux1_next, done_reg, done_next;
    reg [1 : 0] mux2_reg, mux2_next;
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
            key_reg <= 1'b0;
            mux1_reg <= 1'b0;
            mux2_reg <= 2'b0;
            done_reg <= 1'b0;
            RC_reg <= 32'b0;
        end
        else begin
            curr_state <= next_state;
            C_reg <= C_next;
            add_reg <= add_next;
            mix_reg <= mix_next;
            shift_reg <= shift_next;
            sub_reg <= sub_next;
            key_reg <= key_next;
            mux1_reg <= mux1_next;
            mux2_reg <= mux2_next;
            done_reg <= done_next;
            RC_reg <= RC_next;
        end
    end
    
    always@(*)begin
        next_state = curr_state;
        C_next = C_reg;
        add_next = 1'b0;
        mix_next = 1'b0;
        sub_next = 1'b0;
        shift_next = 1'b0;
        key_next = 1'b0;
        mux1_next = 1'b1;
        mux2_next = 2'b01;
        RC_next = 32'h00_00_00_00;
        done_next = 1'b0;
        
        case(C_reg)
            4'd0 : begin
                RC_next = 32'h01_00_00_00;
                mux1_next = 1'b0;
                mux2_next = 2'b00;
            end
            4'd1 : RC_next = 32'h02_00_00_00;
            4'd2 : RC_next = 32'h04_00_00_00;
            4'd3 : RC_next = 32'h08_00_00_00;
            4'd4 : RC_next = 32'h10_00_00_00;
            4'd5 : RC_next = 32'h20_00_00_00;
            4'd6 : RC_next = 32'h40_00_00_00;
            4'd7 : RC_next = 32'h80_00_00_00;
            4'd8 : RC_next = 32'h1B_00_00_00;
            4'd9 : RC_next = 32'h36_00_00_00;
            4'd10 : mux2_next = 2'b10;
            default : begin
                RC_next = 32'h00_00_00_00;
                mux2_next = 2'b10;
            end
        endcase
  
        case(curr_state)
            idle: begin
                if(start)
                    next_state = add;
                else
                    next_state = idle;
            end
            
            add: begin
                add_next = 1'b1;
                next_state = sub;
            end
            
            sub: begin
                if(C_reg == 4'b1010) done_next = 1'b1;
                sub_next = 1'b1;
                next_state = shift;
            end
            
            shift: begin
                shift_next = 1'b1;
                next_state = mix;
            end
            
            mix: begin
                mix_next = 1'b1;
                next_state = key;
            end
            
            key: begin;
                C_next = C_reg + 1;
                key_next = 1'b1;
                next_state = add;
            end
            
            default: begin
                next_state = curr_state;
                C_next = C_reg;
                add_next = 1'b0;
                mix_next = 1'b0;
                sub_next = 1'b0;
                shift_next = 1'b0;
                key_next = 1'b0;
                mux1_next = 1'b1;
                mux2_next = 2'b01;
                RC_next = 32'h00_00_00_00;
                done_next = 1'b0;
            end
        endcase
    end
    
        assign add_start = add_reg;
        assign mix_start = mix_reg;
        assign shift_start = shift_reg;
        assign sub_start = sub_reg;
        assign key_start = key_reg;
        assign mux1_sel = mux1_reg; 
        assign mux2_sel = mux2_reg; 
        assign counter_done = done_reg; 
        assign key_RC = RC_reg;
endmodule