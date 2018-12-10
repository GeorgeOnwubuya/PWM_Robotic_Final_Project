`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2018 04:41:59 PM
// Design Name: 
// Module Name: Counter
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
module Counter
#(parameter N =27)
(
    input logic clk, reset, 
    input logic [N-18:0] value,
    output logic out_tick
 );
 
 //Signal declaration
 logic [N-1:0]count;
 logic [N-1:0]count_next;
 
 
 always_ff@(posedge clk, posedge reset)
    if(reset)
        count <= 0;
    else
        count <= count_next;
        
    assign count_next = (count < {{value, 1'b0} + value, 15'b0}) ? count + 1 : 1'b0;
    assign out_tick = (count == 1) ? 1'b1 : 1'b0;
         
endmodule
