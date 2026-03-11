`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.11.2025 20:47:37
// Design Name: 
// Module Name: cic_tb
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


module cic_tb();
    reg data [0:4096025];
    
    reg clk,clk2,clk3,clk4, reset,enable;
    wire outready,outready2;
    reg  signed [1:0] bits;
    wire signed [37:0] cicout;
    wire signed [39:0] cicout2;
    wire signed [92:0] firout;
    wire signed [63:0] acc;
    
    initial begin
        $readmemh("hz990.mem", data);
    end
    

    initial begin
        clk=0;
        clk2=0;
        clk3=0;
        bits=0;
        enable=0;
        reset = 1;
        #51 reset = 0;
        enable=1;
    end
    always #50 clk=~clk;
    always #3200 clk2=~clk2;
    always #102400 clk3=~clk3;

    
    integer i;
    initial i = 0;
    
    integer fd1,fd2,fd3,fd4;
    initial begin
        fd1 = $fopen("bits.txt","w");
        fd2 = $fopen("cic512_990.txt","w");
        fd3 = $fopen("fircomp.txt","w");
        fd4 = $fopen("cic512_990_by4.txt","w");
    end
    always @(posedge clk) begin
        if (i < 4096026) begin
            if(i%2==0)begin
                bits={1'b0,data[i]};
            end else begin
                bits={2{data[i]}};
            end
            i <= i + 1;
        end else begin
            #200;
            $finish;
        end
    end
    always @(posedge clk) begin
        $fwrite(fd1, "%d\n",  bits); 
    end
    always @(posedge clk) begin
        if(outready)begin
            $fwrite(fd2, "%d\n",  cicout[36:17]); 
        end
    end
    always @(posedge clk3) begin
            $fwrite(fd3, "%d\n",  firout); 
    end
    always @(posedge clk3) begin
        $fwrite(fd4, "%d\n",  cicout[36:17]);
    end
    cic_top #(2,38,4,512) cic(clk,reset,enable,bits,cicout,outready);
    fir #(22,64,7) fir1 (clk3, reset, cicout, firout);
    
endmodule
