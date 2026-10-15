`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/11/2026 12:27:01 PM
// Design Name: 
// Module Name: reciever
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


module reciever(
    input logic bclkx8, rst, rx_data,
    output logic [7:0] data_out,
    output logic rx_status
);

    typedef enum logic [1:0] {
        Idle,
        Start,
        Data,
        Stop
    } state_t;

    state_t state, next_state;
    logic [7:0] rx_shift_reg;
    logic [2:0] bit_counter;
    logic [2:0] sample_counter;

    // State register
    always_ff @(posedge bclkx8 or posedge rst) begin
        if(rst)
            state <= Idle;
        else
            state <= next_state;
    end

    // Next-state logic
    always_comb begin
        next_state = state;
        case(state)
            Idle: begin
                if(!rx_data)      // start bit 0
                    next_state = Start;
            end
            Start: begin
                if(sample_counter == 3'd3) begin
                    if (!rx_data)   
                        next_state = Data;
                    else
                        next_state = Idle;
                end
            end
            Data: begin
                if((sample_counter == 3'd7) && (bit_counter == 3'd7))
                    next_state = Stop;
            end
            Stop: begin
                if(sample_counter == 3'd7)
                    next_state = Idle;
            end
            default: next_state = Idle;
        endcase
    end

    // Datapath and output logic
    always_ff @(posedge bclkx8 or posedge rst) begin
        if(rst) begin
            rx_shift_reg <= 8'b0;
            data_out <= 8'b0;
            bit_counter <= 3'b0;
            sample_counter <= 3'b0;
            rx_status <= 1'b0;
        end
        else begin
            rx_status <= 1'b0;
            case(state)
                Idle: begin
                    sample_counter <= 3'b0;
                    bit_counter <= 3'b0;
                end
                Start: begin
                    if(sample_counter == 3'd3) begin
                        sample_counter <= 3'b0;
                        bit_counter <= 3'b0;
                    end
                    else begin
                        sample_counter <= sample_counter + 1'b1;
                    end
                end
                Data: begin
                    if(sample_counter == 3'd7) begin
                        sample_counter <= 3'b0;
                        rx_shift_reg <= {rx_data, rx_shift_reg[7:1]};
                        if(bit_counter == 3'd7) begin
                            data_out <= {rx_data, rx_shift_reg[7:1]};
                            bit_counter <= 3'b0;
                        end
                        else begin
                            bit_counter <= bit_counter + 1'b1;
                        end
                    end
                    else begin
                        sample_counter <= sample_counter + 1'b1;
                    end
                end
                Stop: begin
                    if(sample_counter == 3'd7) begin
                        sample_counter <= 3'b0;
                        if(rx_data)     // stop bit
                            rx_status <= 1'b1;
                    end
                    else begin
                        sample_counter <= sample_counter + 1'b1;
                    end
                end
                default: begin
                    sample_counter <= 3'b0;
                    bit_counter <= 3'b0;
                end
            endcase
        end
    end
endmodule
