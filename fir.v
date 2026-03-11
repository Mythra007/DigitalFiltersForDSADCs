`timescale 1ns / 1ps

module comb#(
    parameter IW=26,
    parameter OW=26
)(
    input clk,
    input rst,
    input en,
    input signed[IW-1:0] input_data,

    output signed[OW-1:0] output_data,
    output reg out_ready
);
    reg signed[IW-1:0] input_delayed;
    reg signed[OW-1:0] output_data_temp;

    always @(posedge clk)
        begin
            if (rst)
                begin
                    input_delayed <= 0;
                    output_data_temp <= 0;
                    out_ready <= 0;
                end
            else
                begin
                    // input_delayed <= input_data;
                    if (en)
                        begin
                            output_data_temp <= input_data - input_delayed; 
                            input_delayed <= input_data;   
                            out_ready <= 1;
                        end
                    else
                        begin
                            output_data_temp <= output_data_temp;
                            input_delayed <= input_data;
                            out_ready <= 0;
                        end
                end
        end
    assign output_data = output_data_temp;
endmodule