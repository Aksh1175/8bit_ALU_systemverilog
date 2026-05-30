`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 16:50:43
// Design Name: 
// Module Name: alu_logic
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


module alu_logic (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        en,
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    input  logic [1:0]  logic_op,
    output logic [7:0]  result
);
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result <= 8'd0;
        end else if (en) begin
            case (logic_op)
                2'b00: result <= a & b;
                2'b01: result <= a | b;
                2'b10: result <= a ^ b;
                2'b11: result <= ~a;
                default: result <= 8'd0;
            endcase
        end
    end

endmodule