`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 03:25:03 PM
// Design Name: 
// Module Name: transmitter
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


module transmitter(
    input logic bclk,rst,en,
    input logic [7:0]d_in,
    output logic tx_data,tx_status   //tx_status = 1 -> idle/ready , 0 -> busy
);

    // fsm
    typedef enum logic [1:0]{
    Idle = 2'b00,
    Start = 2'b01,
    Data = 2'b10,
    Stop = 2'b11
    } state_t;
    
    state_t state,next_state;
    logic [7:0]tx_shift_reg;
    logic [2:0]bit_counter;
    
    // state reg
    always_ff @(posedge bclk or posedge rst) begin
        if(rst)
            state <= Idle;
        else
            state <= next_state;
     end
     
     // next state logic
     always_comb begin
        next_state = state;
            case(state)
                Idle: 
                    if(en)
                        next_state = Start;
                Start:
                    next_state = Data;
                Data:
                    if(bit_counter == 3'b111)  //all 8 bits sent
                        next_state = Stop;
                Stop:
                    next_state = Idle;
             endcase
        end
    
    
    // output and datapath logic
    always_ff @(posedge bclk or posedge rst) begin
        if(rst) begin
            tx_data <= 1'b1;  // idle high
            tx_status <= 1'b1;  // ready
            tx_shift_reg <= 8'b0;
            bit_counter <= 3'b000;
         end
         else
            case(state)
                Idle: begin
                    tx_data <= 1'b1;
                    tx_status <= 1'b1;
                        if(en)
                            tx_shift_reg <= d_in;
                end
                Start: begin
                    tx_data <= 1'b0;  // start bit
                    tx_status <= 1'b0;  // busy
                    bit_counter <= 3'b000;
                end
                Data: begin
                    tx_data <= tx_shift_reg[0];   //lsb first
                    tx_status <= 1'b0;
                    tx_shift_reg <= {1'b0,tx_shift_reg[7:1]};  //right shift
                    bit_counter <= bit_counter + 1'b1;
                end
                Stop: begin
                    tx_data <= 1'b1;  //stop bit
                    tx_status <= 1'b0;  //busy until next clock
                end
            endcase
        end
                  
endmodule