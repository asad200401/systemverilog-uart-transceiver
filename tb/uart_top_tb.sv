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

    logic clk, rst;
    logic enable;
    logic [7:0] data_in;
    logic rx_data;

    logic tx_data;
    logic [7:0] data_out;
    logic tx_status, rx_status;

    // Loopback connection
    assign rx_data = tx_data;

    // DUT
    uart_top dut (
        .clk       (clk),
        .rst       (rst),
        .enable    (enable),
        .data_in   (data_in),
        .rx_data   (rx_data),
        .tx_data   (tx_data),
        .data_out  (data_out),
        .tx_status (tx_status),
        .rx_status (rx_status)
    );

    // 100 MHz system clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Send one byte and check received data
    task automatic uart_test(input logic [7:0] test_data);
        begin
            // Wait until transmitter is ready
            wait (tx_status == 1'b1);

            @(negedge dut.bclk);
            data_in = test_data;
            enable  = 1'b1;

            @(negedge dut.bclk);
            enable = 1'b0;

            // Wait for receiver to report successful reception
            wait (rx_status == 1'b1);
            #1;

            if (data_out == test_data)
                $display("PASS: Sent = %h, Received = %h",
                         test_data, data_out);
            else
                $display("FAIL: Sent = %h, Received = %h",
                         test_data, data_out);

            // Wait for receiver status pulse to finish
            @(negedge dut.bclkx8);
        end
    endtask

    initial begin
        rst     = 1'b1;
        enable  = 1'b0;
        data_in = 8'h00;

        // Reset
        repeat (5) @(negedge clk);
        rst = 1'b0;

        // Test Case 1
        $display("Test Case 1: 8'hA5");
        uart_test(8'hA5);

        // Allow the UART to return to idle
        wait (tx_status == 1'b1);
        repeat (10) @(negedge dut.bclkx8);

        // Test Case 2
        $display("Test Case 2: 8'h3C");
        uart_test(8'h3C);

        $display("UART testing completed.");
        $finish;
    end

    // Simulation timeout
    initial begin
        #5000000;
        $display("ERROR: Simulation timeout!");
        $finish;
    end

endmodule

