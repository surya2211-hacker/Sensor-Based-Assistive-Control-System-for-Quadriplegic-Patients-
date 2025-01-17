// Main module - State Machine with debouncing
module mainproj (
    input clk,           
    input reset,         
    input [3:0] sw,      
    output reg [3:0] led 
);
    reg [1:0] current_state, next_state;
    reg [3:0] debounce_counter;
    reg [3:0] stable_sw;

    localparam S0 = 2'b00;
    localparam S1 = 2'b01;
    localparam S2 = 2'b10;
    localparam S3 = 2'b11;

    // State machine logi
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Modified debouncing logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            stable_sw <= 4'b0000;
            debounce_counter <= 4'b0000;
        end else begin
            if (sw != stable_sw) begin
                if (debounce_counter < 4'b0100) begin
                    debounce_counter <= debounce_counter + 1;
                end else begin
                    stable_sw <= sw;
                    debounce_counter <= 4'b0000;
                end
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = current_state; // Default: stay in current state
        case (current_state)
            S0: if (stable_sw == 4'b0001) next_state = S1;
            S1: if (stable_sw == 4'b0010) next_state = S2;
            S2: if (stable_sw == 4'b0100) next_state = S3;
            S3: if (stable_sw == 4'b1000) next_state = S0;
            default: next_state = S0;
        endcase
    end

    // LED output logic
    always @(*) begin
        case (current_state)
            S0: led = 4'b0001;
            S1: led = 4'b0010;
            S2: led = 4'b0100;
            S3: led = 4'b1000;
            default: led = 4'b0001;
        endcase
    end

    initial begin
        $monitor("Time=%0d ns | rst=%b | sw=%b | stable_sw=%b | debounce_counter=%b | led=%b",
                 $time, reset, sw, stable_sw, debounce_counter, led);
    end
endmodule

