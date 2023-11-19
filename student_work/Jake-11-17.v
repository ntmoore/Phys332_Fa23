`timescale 1ns / 1ps
module clk_1kHz_1ms(
    input incoming_CLK100MHZ,
    output reg outgoing_CLK
    );
    // creates 1000 Hz clock from a 100 MHz clock 
    // 1000 Hz clock has a period of 0.001 seconds, which is equal to 1ms
    // 100 MHz / 1000 Hz = 100 * 10^6 / 1000 = 100,000 cycles
    // log_2(100,000) = 16.61, so 17 bits are needed for the counter
    reg[16:0] ctr=0;

    always @ (posedge incoming_CLK100MHZ) begin
        if (ctr == 49_999) begin
            outgoing_CLK <= 1'b1;
            ctr <= ctr + 1;            
        end else if (ctr == 99_999) begin
            outgoing_CLK <= 1'b0;
            ctr <= 0;
        end else begin
            ctr <= ctr + 1;
        end
    end
endmodule

module clk_50Hz(
    input incoming_CLK100MHZ,
    output reg outgoing_CLK
    );

    // creates 10HZ clock from a 100MHZ clock
    // 10HZ clock has a period of 0.1 second = 100ms
    // 100MHz / 5Hz => (100 * (1000) * (1000)) / 20 = 2,000,000 cycles
    // log2(10,000,000) = 23.2, so 24 bits needed for counter
    reg [23:0] ctr;

    always @ (posedge incoming_CLK100MHZ) begin
        if (ctr == 10_000_000) begin
            outgoing_CLK <= 1'b1;
            ctr <= ctr + 1;            
        end else if (ctr == 19_999_999) begin
            outgoing_CLK <= 1'b0;
            ctr <= 0;
        end else begin
            ctr <= ctr + 1;
        end
    end

endmodule
 
module count_button_push( 
    input CLK_IN, 
    input button,
    input clear,
    output reg [15:0] sum_out
    );

    always @(posedge CLK_IN) begin
        if ( clear==1 ) begin
            sum_out <= 0;
        end else if (button==1) begin
            sum_out <= sum_out + 1'b1;
        end        
    end

endmodule

module implement_count_up_and_display(
    input CLK100MHZ,
    input BTNR, // left button on Nexys4DDR
    input [1:0] SW, // right button
    output [15:0] LED
    );

    wire CLK_50HZ;
    clk_50Hz d0( .incoming_CLK100MHZ(CLK100MHZ), .outgoing_CLK(CLK_50HZ));
    
    // set up a counter
    count_button_push d1 ( .CLK_IN(CLK_50HZ), .button(BTNR), .clear(SW[1:0]), .sum_out(LED[15:0]));

    endmodule
 
