`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 16:49:39
// Design Name: 
// Module Name: alu_arith
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

module alu_arith (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    input  logic [1:0]  arith_op,
    output logic [7:0]  result,
    output logic        carry_out,
    output logic        overflow
);
    logic [8:0] temp;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result    <= 8'd0;
            carry_out <= 1'b0;
            overflow  <= 1'b0;
        end else if (en) begin
            case (arith_op)
                2'b00: temp = {1'b0,a} + {1'b0,b};
                2'b01: temp = {1'b0,a} - {1'b0,b};
                2'b10: temp = {1'b0,a} + 9'd1;
                2'b11: temp = {1'b0,a} - 9'd1;
                default: temp = 9'd0;
            endcase
            result    <= temp[7:0];
            carry_out <= temp[8];
            overflow  <= (a[7] == b[7]) && (temp[7] != a[7]);
        end
    end

endmodule