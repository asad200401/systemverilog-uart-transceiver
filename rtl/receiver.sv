`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 03:25:16 PM
// Design Name: 
// Module Name: receiver
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


//module receiver (
//    input  logic        bclkx8,    // 8x baud rate clock for oversampling
//    input  logic        reset,     // Active high reset
//    input  logic        rx_data,   // Serial data input
//    output logic [7:0]  d_out,     // Parallel data output
//    output logic        rx_status  // 1: Data Ready, 0: Busy
//);

//    // FSM states
//    typedef enum logic [1:0] {
//        IDLE  = 2'b00,
//        START = 2'b01,
//        DATA  = 2'b10,
//        STOP  = 2'b11
//    } state_t;

//    state_t state, next_state;
    
//    logic [7:0] rx_shift_reg;      // Shift register for received data
//    logic [2:0] bit_counter;       // Counts received bits
//    logic [2:0] sample_counter;    // Counts samples (0-7)
//    logic [2:0] majority_vote;     // For noise filtering
//    logic start_bit_detected;

//    // Synchronize input
//    logic rx_sync1, rx_sync2;
//    always_ff @(posedge bclkx8 or posedge reset) begin
//        if (reset) begin
//            rx_sync1 <= 1'b1;
//            rx_sync2 <= 1'b1;
//        end else begin
//            rx_sync1 <= rx_data;
//            rx_sync2 <= rx_sync1;
//        end
//    end

//    // State register
//    always_ff @(posedge bclkx8 or posedge reset) begin
//        if (reset)
//            state <= IDLE;
//        else
//            state <= next_state;
//    end

//    // Next state logic
//    always_comb begin
//        next_state = state;  // Default: stay in current state
        
//        case (state)
//            IDLE: begin
//                if (start_bit_detected)
//                    next_state = START;
//            end
            
//            START: begin
//                if (sample_counter == 3'b111)  // 8 samples taken
//                    next_state = DATA;
//            end
            
//            DATA: begin
//                if (bit_counter == 3'b111 && sample_counter == 3'b111)  // All 8 bits received
//                    next_state = STOP;
//            end
            
//            STOP: begin
//                if (sample_counter == 3'b111)  // Stop bit sampled
//                    next_state = IDLE;
//            end
//        endcase
//    end

//    // Sample counter and majority vote logic
//    always_ff @(posedge bclkx8 or posedge reset) begin
//        if (reset) begin
//            sample_counter <= 3'b000;
//            majority_vote <= 3'b000;
//            start_bit_detected <= 1'b0;
//        end else begin
//            case (state)
//                IDLE: begin
//                    if (!rx_sync2) begin  // Start bit detection
//                        start_bit_detected <= 1'b1;
//                        sample_counter <= 3'b000;
//                    end
//                end
                
//                default: begin  // START, DATA, STOP states
//                    sample_counter <= sample_counter + 1'b1;
//                    if (rx_sync2)
//                        majority_vote <= majority_vote + 1'b1;
                        
//                    if (sample_counter == 3'b111) begin
//                        majority_vote <= 3'b000;
//                        start_bit_detected <= 1'b0;
//                    end
//                end
//            endcase
//        end
//    end

//    // Data path logic
//    always_ff @(posedge bclkx8 or posedge reset) begin
//        if (reset) begin
//            rx_shift_reg <= 8'b0;
//            bit_counter <= 3'b000;
//            d_out <= 8'b0;
//            rx_status <= 1'b0;
//        end else begin
//            case (state)
//                IDLE: begin
//                    rx_status <= 1'b0;
//                    bit_counter <= 3'b000;
//                end

//                DATA: begin
//                    if (sample_counter == 3'b111) begin  // Sample at middle point
//                        rx_shift_reg <= {(majority_vote >= 3'b100), rx_shift_reg[7:1]};
//                        bit_counter <= bit_counter + 1'b1;
//                    end
//                end

//                STOP: begin
//                    if (sample_counter == 3'b111) begin
//                        if (majority_vote >= 3'b100) begin  // Valid stop bit
//                            d_out <= rx_shift_reg;
//                            rx_status <= 1'b1;  // Data ready
//                        end
//                    end
//                end
//            endcase
//        end
//    end

//endmodule




module receiver(
    input logic bclkx8,rst,rx_data,
    output logic [7:0]d_out,
    output logic rx_status     // 1-> data ready , 0-> busy
);

    // fsm
    typedef enum logic [1:0]{
    Idle = 2'b00,
    Start = 2'b01,
    Data = 2'b10,
    Stop = 2'b11
    } state_t;
    
    state_t state,next_state;
    logic [7:0]rx_shift_reg;
    logic [2:0]bit_counter,sample_counter,majority_vote;
    logic start_bit_detected;
    
    // synchronize input to avoid metastability
    logic rx_sync1,rx_sync2;
    always_ff @(posedge bclkx8 or posedge rst) begin
        if(rst) begin   
            rx_sync1 <= 1'b1;
            rx_sync2 <= 1'b1;
        end
        else begin
            rx_sync1 <= rx_data;
            rx_sync2 <=rx_sync1;
        end
     end
     
     // state reg
     always_ff @(posedge bclkx8 or posedge rst) begin
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
                    if(start_bit_detected)
                        next_state = Start;
                Start:
                    if(sample_counter == 3'b111)  //8 samples taken
                        next_state = Data;
                Data:
                    if(sample_counter == 3'b111 && bit_counter ==3'b111)
                        next_state = Stop;
                Stop:
                    if(sample_counter == 3'b111)
                        next_state = Idle;
            endcase
     end
                
    // sample counter & majority vote logic
    always_ff @(posedge bclkx8 or posedge rst) begin
        if(rst) begin
            sample_counter <= 3'b000;
            majority_vote <= 3'b000;
            start_bit_detected <= 1'b0;
        end
        else
            case(state)
                Idle:
                    if(!rx_sync2) begin   // start bit detection
                        start_bit_detected <= 1'b1;
                        sample_counter <= 3'b000;
                    end
                default: begin   //start, data and stop states
                    sample_counter <= sample_counter + 1'b1;
                        if(rx_sync2)
                            majority_vote <= majority_vote + 1'b1;
                        if(sample_counter == 3'b111) begin
                            majority_vote <= 3'b000;
                            start_bit_detected <= 1'b0;
                        end
                end
            endcase 
    end
    
    
    // datapath logic
    always_ff @(posedge bclkx8 or posedge rst) begin
        if(rst) begin
            rx_shift_reg <= 8'b0;
            bit_counter <= 3'b000;
            d_out <= 8'b0;
            rx_status <= 1'b0;
        end
        else
            case(state)
                Idle: begin
                    rx_status <= 1'b0;
                    bit_counter <= 3'b000;
                end
                Data: 
                    if(sample_counter == 3'b111) begin  //sample at middle point
                        rx_shift_reg <= {(majority_vote >= 3'b100),rx_shift_reg[7:1]};
                        bit_counter <= bit_counter + 1'b1;
                    end
                Stop: 
                    if(sample_counter == 3'b111) begin
                        if(majority_vote >= 3'b100) begin  // valid stop bit
                            d_out <= rx_shift_reg;
                            rx_status <= 1'b1;  // data ready
                        end
                    end
              endcase
     end

endmodule