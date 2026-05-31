`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 03:25:48 PM
// Design Name: 
// Module Name: uart_top
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


module uart_top(
    input logic clk,rst,en,
    input logic [7:0]d_in,
    input logic rx_data,
    output logic tx_data,tx_status,rx_status,
    output logic [7:0]d_out
);

    logic bclk,bclkx8;
    
    baud_rate_generator brg (.clk(clk),.rst(rst),.bclk(bclk),.bclkx8(bclkx8));
    
    transmitter tx (.bclk(bclk),.rst(rst),.en(en),.d_in(d_in),.tx_data(tx_data),.tx_status(tx_status));
    
    receiver rx (.bclkx8(bclkx8),.rst(rst),.rx_data(rx_data),.d_out(d_out),.rx_status(rx_status));
    
endmodule