`timescale 1ns / 1ps

module downsampler#(
    parameter W=16,
    parameter DECIMATION_FACTOR=32
)(
    input clk,
    input rst,
    input en,
    input signed[W-1:0] input_data,

    output signed[W-1:0] output_data,
    output reg out_ready
);
    localparam COUNTER_WIDTH = $clog2(DECIMATION_FACTOR);
    reg [COUNTER_WIDTH-1:0] counter;
    reg signed[W-1:0] out;

    always @(posedge clk or posedge rst)
        begin
            if (rst)
                begin
                    counter <= {COUNTER_WIDTH{1'b0}};
                    out_ready <= 1'b0;
                    out <= {W{1'b0}};
                end
            else
                begin
                    if (en)
                        begin
                            if (counter == DECIMATION_FACTOR-1)
                                begin
                                    counter <= {COUNTER_WIDTH{1'b0}};
                                    out_ready <= 1'b1;
                                    out <= input_data;
                                end
                            else
                                begin
                                    counter <= counter + 1'b1;
                                    out_ready <= 1'b0;
                                    out <= out;
                                    // out <= {W{1'b0}};
                                end
                        end
                    else
                        begin
                            counter <= counter;
                            out_ready <= 1'b0;
                            out <= out;
                        end
                end
        end

    assign output_data = out;  
endmodule