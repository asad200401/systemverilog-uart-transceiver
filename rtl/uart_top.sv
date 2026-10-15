`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 06:20:21 PM
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
    input logic clk, rst, enable, rx_data,
    input logic [7:0] data_in,
    output logic tx_data, tx_status, rx_status,
    output logic [7:0] data_out
);

    logic bclk, bclkx8;

    baud_rate_generator brg (.clk(clk),.rst(rst),.bclk(bclk),.bclkx8(bclkx8));
    
    transmitter tx (.bclk(bclk),.rst(rst),.enable(enable),.data_in(data_in),.tx_data(tx_data),.tx_status(tx_status));

    reciever rx (.bclkx8(bclkx8),.rst(rst),.rx_data(rx_data),.data_out(data_out),.rx_status(rx_status));

endmodule
