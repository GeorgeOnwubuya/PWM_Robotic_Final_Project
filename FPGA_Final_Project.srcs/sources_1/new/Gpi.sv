`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2018 04:15:44 PM
// Design Name: 
// Module Name: Gpi
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

module Gpi
    #(parameter W = 8) //width of input port
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
     //External signal
     input logic [W-1:0] din
    );
    
    //Signal Declaration
    logic [W-1:0] sw_rd_data_reg, btn_rd_data_reg;
    logic rd_en;
    logic [1:0] reg_signal; 
    
    //Body
    always_ff @(posedge clk, posedge reset)
        if(reset) begin
            sw_rd_data_reg <= 0;
        end
        else if(rd_en && reg_signal[0]) 
        begin
            sw_rd_data_reg <= din;
        end
        
    always_ff @(posedge clk, posedge reset)
        if(reset) begin
            btn_rd_data_reg <= 0;
        end
        else if(rd_en && reg_signal[1])
        begin
            btn_rd_data_reg <= din;
        end    
        
    //Decoding Logic    
    assign rd_en = cs && read;    
      
    always_comb
    begin
        case(addr)
            5'h0:
            begin
                reg_signal = 2'b01;
                rd_data[W-1:0] = sw_rd_data_reg;
            end
            5'h1:
            begin
                reg_signal = 2'b10;
                rd_data[W-1:0] = btn_rd_data_reg;
            end
            default:
            begin
                reg_signal[1:0] = 2'b00;
            end
        endcase
    end

//write interface    
assign wr_data = 0;
//external output
assign rd_data[31:W] = 0;
                 
endmodule
