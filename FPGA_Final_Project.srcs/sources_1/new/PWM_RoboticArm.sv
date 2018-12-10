`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2018 07:24:35 PM
// Design Name: 
// Module Name: PWM_RoboticArm
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


module PWM_RoboticArm
#(parameter 
    R = 10,      //# bits for PWM resolution (2^R levels)
    W = 6       //# bits (width) of the output port
)
     
( input logic clk, 
  input logic reset, 
  
  //Slot Interface
  input logic cs,
  input logic read,
  input logic write,
  input logic [4:0] addr,
  input logic [31:0] wr_data,
  output logic [31:0] rd_data,
  //external signal
  output logic [W-1:0] pwm_out  
 ); 
  
  //Signal Declerations
  logic [R:0] duty_2d_reg [W-1:0];      //Create memory using an unpacked & packed vector
  logic duty_array_en, dvsr_en;         //enable pins for writing to divisor and duty cycle register 
  logic [31:0] q_reg;
  logic [31:0] q_next;
  logic [R-1:0] d_reg;
  logic [R-1:0] d_next;
  logic [R:0] d_ext;
  logic [W-1:0] pwm_reg;
  logic [W-1:0] pwm_next;
  logic tick;
  logic [31:0] dvsr_reg;

ila_0 pwmILA (
	.clk(clk), // input wire clk


	.probe0(cs), // input wire [0:0]  probe0  
	.probe1(write), // input wire [0:0]  probe1 
	.probe2(wr_data), // input wire [0:0]  probe2 
	.probe3(addr) // input wire [0:0]  probe3 
);

//*************************************************************
// Wrapping Circuit
//*************************************************************

//Decoding
assign duty_array_en = cs && write && addr[4]; 
assign dvsr_en = cs && write && addr == 5'b00000;

//Register for the divisor
always_ff @(posedge clk, posedge reset)
    if(reset) begin
        dvsr_reg <= 0;
    end
    else if(dvsr_en) begin
        dvsr_reg <= wr_data;
    end
    
//Register for duty cycle
always_ff @(posedge clk)
    if(duty_array_en) begin
        duty_2d_reg[addr[3:0]] <= wr_data[R:0];
    end
        
//**************************************************************            
// Multi-Bit PWM
//**************************************************************

always_ff @(posedge clk, posedge reset)
    if(reset) begin
        d_reg <= 0;
        q_reg <= 0;
        pwm_reg <= 0;
    end
    else begin
        d_reg <= d_next;
        q_reg <= q_next;
        pwm_reg <= pwm_next;
    end    
  
//"Prescale" Counter (sets q_reg to zero when its equal to dvsr and set a tick pin) 
assign q_next = (q_reg == dvsr_reg) ? 0 : q_reg + 1;
assign tick = (q_reg == 0); //sets tick when q_reg rolls over 

//duty cycle counter
assign d_next = (tick) ? d_reg + 1 : d_reg;
assign d_ext = {1'b0, d_reg};

//comparison circuit 
generate
    genvar i;
    for (i=0; i<W; i=i+1) begin
        assign pwm_next[i] = (d_ext < duty_2d_reg[i]); //sets pwm_next when data_extension is less than the duty cycle.
    end
endgenerate
assign pwm_out = pwm_reg;

//read data not used for this slot 
assign rd_data = 32'b0;
endmodule
