`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 03:26:03 PM
// Design Name: 
// Module Name: uart_top_tb
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


module uart_top_tb;
    logic clk;
    logic rst;
    logic [7:0]d_in;
    logic en;
    logic rx_data;
    logic tx_data;
    logic tx_status;
    logic rx_status;
    logic [7:0]d_out;

    uart_top dut (.clk(clk),.rst(rst),.d_in(d_in),.en(en),.rx_data(rx_data),.tx_data(tx_data),.tx_status(tx_status),.rx_status(rx_status),.d_out(d_out));

    // connecting transmitter to receiver for loopback testing
    assign rx_data = tx_data;

    initial begin
        clk = 0;
        forever #5ns clk = ~clk;
    end

    initial begin
        // Initialize
        rst = 1;
        en = 0;
        d_in = 8'h00;
        #10us;
        rst = 0;
        #10us;

        // send and receive 0x55
        d_in = 8'h55;
        en = 1;
        #104.167us;  // one bit time
        en = 0;
        wait(tx_status);
        wait(rx_status);

        wait(!rx_status);
        #500us;

        // send and receive 0xAA
        d_in = 8'hAA;
        en = 1;
        #104.167us;
        en = 0;
        wait(tx_status);
        wait(rx_status);
        #500us;
        $stop;
    end
endmodule
