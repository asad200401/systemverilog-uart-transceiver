`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 03:25:33 PM
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
    input logic clk,rst,
    output logic bclk,bclkx8
);

    // bclk_div = 100000000/9600 = 10416.6 => 10417 , baud_rate = 9600 , clk = 100MHz
    // bclkx8_div = 100000000/9600*8 = 1302 , 8x baud_rate clock for receiver
    
    localparam bclk_div = 16'd10417;
    localparam bclkx8_div = 16'd1302;
    
    logic [15:0]bclk_counter,bclkx8_counter;
    
    // bclk
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
           bclk_counter <= '0;
           bclk <= 1'b0;
        end
        else 
            if(bclk_counter == (bclk_div - 1)) begin 
                bclk_counter <= '0;
                bclk <= ~ bclk;
            end 
            else
                bclk_counter <= bclk_counter + 1;
    end
    
    // bclkx8
    always_ff @(posedge clk or posedge rst) begin
        if(rst) begin
            bclkx8_counter <= '0;
            bclkx8 <= 1'b0;
        end
        else 
            if(bclkx8_counter == (bclkx8_div - 1)) begin
                bclkx8_counter <= '0;
                bclkx8 <= ~bclkx8;
            end
            else
                bclkx8_counter <= bclkx8_counter + 1;
    end
    
endmodule