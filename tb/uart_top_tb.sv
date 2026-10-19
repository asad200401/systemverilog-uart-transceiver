`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 06:20:40 PM
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

logic clk, rst, enable;
logic [7:0] data_in;
logic rx_data, tx_data;
logic [7:0] data_out;
logic tx_status, rx_status;

assign rx_data = tx_data;

uart_top dut (
    .clk(clk),
    .rst(rst),
    .enable(enable),
    .data_in(data_in),
    .rx_data(rx_data),
    .tx_data(tx_data),
    .data_out(data_out),
    .tx_status(tx_status),
    .rx_status(rx_status)
);

initial clk = 0;
always #5 clk = ~clk;

task uart_test;
    input [7:0] test_data;
    begin
        wait(tx_status == 1);
        @(negedge dut.bclk);
        data_in = test_data;
        enable = 1;
        @(negedge dut.bclk);
        enable = 0;
        wait(rx_status == 1);
        @(negedge dut.bclkx8);
    end
endtask

initial begin
    rst = 1;
    enable = 0;
    data_in = 0;

    repeat(5) @(negedge clk);
    rst = 0;

    uart_test(8'hA5);
    wait(tx_status == 1);
    repeat(10) @(negedge dut.bclkx8);

    uart_test(8'h3C);

    $finish;
end

initial begin
    #5000000;
    $finish;
end

endmodule

