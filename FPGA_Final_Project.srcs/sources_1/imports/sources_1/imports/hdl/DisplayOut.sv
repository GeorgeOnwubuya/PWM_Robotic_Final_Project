module my_sseg
   #(parameter W = 8)  // width of output port
   (
    input  logic clk,
    input  logic reset,

    // slot interface
    input  logic cs,
    input  logic read,
    input  logic write,
    input  logic [4:0] addr,
    input  logic [31:0] wr_data,
    output logic [31:0] rd_data,
    // external ports for seven segment 
    output logic [7:0] sseg,
    output logic [7:0] AN
    
   );
   // declaration
   logic [31:0] buf_reg_0, buf_reg_1; //use one register for all digits
   logic wr_en;
   logic [3:0] hex0, hex1, hex2, hex3;
   logic [3:0] hex4, hex5, hex6, hex7;
   logic [1:0]   reg_signal;

   // body
   // output buffer register
   always_ff @(posedge clk, posedge reset)
      if (reset)
         buf_reg_0 <= 0;
      else   
         if (wr_en && reg_signal[0])
            buf_reg_0 <= wr_data[W-1:0];
            
   always_ff @(posedge clk, posedge reset)
      if (reset)
        buf_reg_1 <= 0;
      else   
        if (wr_en && reg_signal[1])
            buf_reg_1 <= wr_data[W-1:0];   
            
    // decoding logic 
   assign wr_en = cs && write;
   
   always_comb 
   begin
    case(addr)
        5'h0:
        begin
            reg_signal = 2'b01;
        end
        5'h1: 
        begin
            reg_signal = 2'b10;
        end
        default: 
        begin
            reg_signal[1:0] = 2'b00;    
        end
    endcase       
   end
  
   // slot read interface
   assign rd_data =  0;
   
   
Display_8Bit seven_seg(
.clk(clk), 
.reset(reset), 
.hex7(buf_reg_0[31:28]),
.hex6(buf_reg_0[27:24]), 
.hex5(buf_reg_0[23:20]), 
.hex4(buf_reg_0[19:16]), 
.hex3(buf_reg_0[15:12]), 
.hex2(buf_reg_0[11:8]), 
.hex1(buf_reg_0[7:4]), 
.hex0(buf_reg_0[3:0]),
.value(buf_reg_1), 
.an(AN),   
.sseg(sseg)   
);
endmodule
       



