`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 12:26:23 PM
// Design Name: 
// Module Name: baud_rate_generator
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


module baud_rate_generator(
    input logic clk, rst,
    output logic bclk, bclkx8
);
    localparam baud_div = 16'd5208;         // baud_div = 100,000,000/2*9600 = 5208 
    localparam baud_div_x8 = 16'd651;      // fbclkx8 = 8*9600 = 76800,  baud_div_x8 = 100,000,000/2*76800 = 651
    logic [15:0] bclk_counter, bclkx8_counter;
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            bclk_counter <= '0;
            bclk <= 1'b0;
        end
        else begin
            if(bclk_counter == baud_div - 1) begin
                bclk_counter <= '0;
                bclk <= ~bclk;
            end
            else begin
                bclk_counter <= bclk_counter + 1'b1;
            end
        end      
    end
    
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            bclkx8_counter <= '0;
            bclkx8 <= 1'b0;
        end
        else begin
            if(bclkx8_counter == baud_div_x8 - 1) begin
                bclkx8_counter <= '0;
                bclkx8 <= ~bclkx8;
            end
            else begin
                bclkx8_counter <= bclkx8_counter + 1'b1;
            end
        end
    end
    
endmodule
