`timescale 1ns / 1ps

module all_integrators#(
    parameter IW = 1,
    parameter OW = 26,
    parameter N = 5
)(
    input clk,
    input rst,
    input en,
    input signed[IW-1:0] din,
    output signed[OW-1:0] dout,
    output out_ready
);
    wire signed [OW-1:0] stage [0:N];
    wire[N:0] out_ready_temp;

    assign stage[0] = {{(OW-IW){din[IW-1]}}, din};
    assign out_ready_temp[0] = en;

    genvar i;
    generate
        for(i=0; i<N; i=i+1)
            begin
                integrator #(.IW(OW), .OW(OW))
                integrator(
                    .clk(clk),
                    .rst(rst),
                    .en(out_ready_temp[i]),
                    .input_data(stage[i]),
                    .output_data(stage[i+1]),
                    .out_ready(out_ready_temp[i+1])
                );
            end
    endgenerate

    assign dout = stage[N];
    assign out_ready = out_ready_temp[N];
endmodule