`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2018 05:04:39 PM
// Design Name: 
// Module Name: Gpo
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


module Gpo
    #(parameter W = 8) //width of output port
   
    (
     input logic clk,
     input logic reset,
     //Slot Interface
     input logic cs,
     input logic read,
     input logic write,
     input logic [4:0] addr,
     input logic [31:0] wr_data,
     output logic [31:0] rd_data,
     //external port
     output logic [W-1:0] dout
    );
    
    //Signal Declarations
    logic [W-1:0] led_wr_data_reg;
    logic wr_en;
    
    //Body
    always_ff @(posedge clk, posedge reset)
        if(reset) begin
            led_wr_data_reg <= 0;
        end 
        else if(wr_en)
        begin
            led_wr_data_reg <= wr_data[W-1:0];
        end
    
    //decoding logic
    assign wr_en = cs && write;
    //reading interface
    assign rd_data = 0;
    //external output
    assign dout = led_wr_data_reg;    
    
endmodule
