`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 09:16:46 PM
// Design Name: 
// Module Name: BlockRam_Wrapper
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


module BlockRam_Wrapper
#(parameter W = 16)
(
input logic clk,
input logic reset,

//Slot interface
input logic cs,
input logic read,
input logic write,
input logic [3:0] addr,
input logic [31:0] wr_data,
output logic [31:0] rd_data 
);

//Signal Declarations
logic wea_reg;
logic [W-1:13] addra_reg;
logic [W-1:13] addrb_reg;
logic [W-1:0] dina_reg;
logic [W-1:0] doutb_reg;

//*************************************************************
// Wrapping Circuit
//*************************************************************

//Decoding 
always_ff @(posedge clk)
    if(cs && write && (addr == 3'b001)) begin
        wea_reg <= wr_data;
    end
    else begin
        wea_reg <= 0;
    end
        
assign addra_reg = (cs && write && (addr == 3'b010)) ? wr_data : 0;
assign addrb_reg = (cs && write && (addr == 3'b011)) ? wr_data : 0;
assign dina_reg  = (cs && write && (addr == 3'b100)) ? wr_data : 0;
assign doutb_reg = (cs && write && (addr == 3'b101)) ? rd_data : 0;

    
blk_mem_gen_0 block_ram (
.clka(clk),         // input wire clka
.wea(wea_reg),      // input wire [0 : 0] wea
.addra(addra_reg),  // input wire [2 : 0] addra
.dina(dina_reg),    // input wire [15 : 0] dina
.clkb(clk),         // input wire clkb
.addrb(addrb_reg),  // input wire [2 : 0] addrb
.doutb(doutb_reg)  // output wire [15 : 0] doutb
);
       
endmodule
