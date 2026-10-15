`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 12:26:42 PM
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
    input logic bclk, rst, enable,
    input logic [7:0] data_in,
    output logic tx_data, tx_status
);
    typedef enum logic [1:0] {
        Idle,
        Start, 
        Data, 
        Stop
        } state_t;
    
    state_t state, next_state;
    logic [7:0] tx_shift_reg;
    logic [2:0] bit_counter;
    
        
     // State register
    always_ff @(posedge bclk or posedge rst) begin
        if(rst)
            state <= Idle;
        else 
            state <= next_state;
    end    
        
    // Next state logic
    always_comb begin
        next_state = state;
            case(state)
                Idle: begin
                    if(enable)
                        next_state = Start;
                    end
                Start: begin
                    next_state = Data;
                    end
                Data: begin
                    if(bit_counter == 3'b111)
                        next_state = Stop;
                    end
                Stop: begin
                    next_state = Idle;
                    end
                default: next_state = Idle;
             endcase
          end
          
     // Output and Datapath Logic
     always_ff @(posedge bclk or posedge rst) begin
        if(rst) begin
            tx_data <= 1'b1; // Idle high
            tx_status <= 1'b1; // Ready
            bit_counter <= 3'b000;
            tx_shift_reg <= 8'b0;  
        end
        else begin
            case(state)
            Idle: begin
                tx_data <= 1'b1;
                tx_status <= 1'b1;
                    if(enable)
                        tx_shift_reg <= data_in;
            end 
            Start: begin
                tx_data <= 1'b0; // start bit
                tx_status <= 1'b0; // busy
                bit_counter <= 3'b000;
            end
            Data: begin
                tx_data <= tx_shift_reg[0];  // LSB
                tx_status <= 1'b0;
                tx_shift_reg <= {1'b0, tx_shift_reg[7:1]}; // right shift
                bit_counter <= bit_counter + 1'b1;
            end      
            Stop: begin 
                tx_data <= 1'b1;  // stop bit
                tx_status <= 1'b0;
            end
         endcase  
        end    
      end
endmodule
