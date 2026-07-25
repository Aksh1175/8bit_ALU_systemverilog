`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 16:51:34
// Design Name: 
// Module Name: alu_top
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


module alu_top (
    input  logic        clk,
    input  logic        rst_n,
    input  logic        te,
    input  logic [7:0]  a,
    input  logic [7:0]  b,
    input  logic [2:0]  op,
    output logic [7:0]  result,
    output logic        carry,
    output logic        zero,
    output logic        overflow,
    output logic        negative
);

    logic arith_en, logic_en;
    assign arith_en = ~op[2];
    assign logic_en =  op[2];

    // Clock gate cells (for synthesis power report)
    logic arith_clk, logic_clk;
    clock_gate cg_arith (.clk(clk), .en(arith_en), .te(te), .gated_clk(arith_clk));
    clock_gate cg_logic (.clk(clk), .en(logic_en), .te(te), .gated_clk(logic_clk));

    // Operand isolation
    logic [7:0] a_iso, b_iso;
    assign a_iso = arith_en ? a : 8'h00;
    assign b_iso = arith_en ? b : 8'h00;

    logic [7:0] arith_result, logic_result;
    logic       arith_carry,  arith_ovf;

    // Units use global clk + enable - clean simulation, same RTL intent
    alu_arith u_arith (
        .clk      (clk),
        .rst_n    (rst_n),
        .en       (arith_en),
        .a        (a_iso),
        .b        (b_iso),
        .arith_op (op[1:0]),
        .result   (arith_result),
        .carry_out(arith_carry),
        .overflow (arith_ovf)
    );

    alu_logic u_logic (
        .clk      (clk),
        .rst_n    (rst_n),
        .en       (logic_en),
        .a        (a),
        .b        (b),
        .logic_op (op[1:0]),
        .result   (logic_result)
    );

    // Output MUX + flags
    logic [7:0] mux_result;
    assign mux_result = op[2] ? logic_result : arith_result;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            result   <= 8'd0;
            carry    <= 1'b0;
            zero     <= 1'b0;
            overflow <= 1'b0;
            negative <= 1'b0;
        end else begin
            result   <= mux_result;
            carry    <= arith_en ? arith_carry : 1'b0;
            overflow <= arith_en ? arith_ovf   : 1'b0;
            zero     <= (mux_result == 8'd0);
            negative <= mux_result[7];
        end
    end

endmodule