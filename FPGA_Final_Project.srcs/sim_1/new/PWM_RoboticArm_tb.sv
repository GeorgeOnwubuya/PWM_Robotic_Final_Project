`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2018 09:10:09 PM
// Design Name: 
// Module Name: PWM_RoboticArm_tb
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


module PWM_RoboticArm_tb();

//Input & Output Declaration
logic clk;
logic reset;
logic [31:0] dvsr;
logic [7:0] duty;
logic pwm_out;

//Instantiation 
PWM_RoboticArm Dut (
.clk(clk),
.reset(reset),
.dvsr(dvsr),
.duty(duty),
.pwm_out(pwm_out)
);

always
    begin
        clk = 1'b1;
        #5;
        clk = 1'b0;
    end

initial
    begin
        reset = 1'b1;
        #30;    
        reset = 1'b0;
        #10
        dvsr = 6'b100000;
        #10
        duty = 8'b10000000;         
    end






endmodule
