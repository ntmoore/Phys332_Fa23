`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Module Name: lab1
//////////////////////////////////////////////////////////////////////////////////


module lab1(
    input [7:0] SW,
     output [7:0] LED
    );
    
    assign LED[0] = ~SW[0];
    assign LED[1] = SW[1] & ~SW[2];
    assign LED[3] = SW[2] & SW[3];
    assign LED[2] = LED[1] | LED[3];
    
    assign LED[7:4] = SW[7:4];
    
endmodule
