// Updated testbench
module tbproj;
    reg clk;
    reg reset;
    reg [3:0] sw;
    wire [3:0] led;

    // Instantiate mainproj
    mainproj uut (
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .led(led)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100 MHz clock
    end

    // Enhanced test sequence
    initial begin
        // Initialize
        reset = 1;
        sw = 4'b0000;
        
        // Reset sequence
        #20 reset = 0;
        
        // Wait for stable initial state
        #50;

        // Test sequence with longer delays
        // State 0 -> 1
        sw = 4'b0001;
        #100;  // Wait for debounce and state change
        
        // State 1 -> 2
        sw = 4'b0010;
        #100;
        
        // State 2 -> 3
        sw = 4'b0100;
        #100;
        
        // State 3 -> 0
        sw = 4'b1000;
        #100;
        
        // Return to initial
        sw = 4'b0000;
        #100;

        // Additional test cycle
        sw = 4'b0001;
        #100;
        sw = 4'b0010;
        #100;
        
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time=%0d ns | Reset=%b | Switch=%b | LED=%b | State=%b | Stable_SW=%b",
                 $time, reset, sw, led, uut.current_state, uut.stable_sw);
    end
endmodule
