`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 16:48:44
// Design Name: 
// Module Name: clock_gate
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

module clock_gate (
    input  logic clk,
    input  logic en,
    input  logic te,
    output logic gated_clk
);
    assign gated_clk = clk & (en | te);
endmodule