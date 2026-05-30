`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 16:52:55
// Design Name: 
// Module Name: alu_tb
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


//`timescale 1ns/1ps
module alu_tb;

    // ---------------------------------------------------
    // DUT signals
    // ---------------------------------------------------
    logic        clk, rst_n, te;
    logic [7:0]  a, b;
    logic [2:0]  op;
    logic [7:0]  result;
    logic        carry, zero, overflow, negative;

    // ---------------------------------------------------
    // DUT instantiation
    // ---------------------------------------------------
    alu_top dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .te       (te),
        .a        (a),
        .b        (b),
        .op       (op),
        .result   (result),
        .carry    (carry),
        .zero     (zero),
        .overflow (overflow),
        .negative (negative)
    );

    // ---------------------------------------------------
    // Clock : 10 ns period
    // ---------------------------------------------------
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // ---------------------------------------------------
    // XSIM waveform capture
    // ---------------------------------------------------
    //initial begin
      //  $recordfile("alu_tb");
        //$recordvars("depth=0", alu_tb);
    //end
    
    initial begin
      $dumpfile("alu.vcd");
      $dumpvars(0, alu_tb);
    end

    // ---------------------------------------------------
    // Task : apply one operation and print result
    // ---------------------------------------------------
   task automatic apply_op (
    input logic [7:0] ta,
    input logic [7:0] tb,
    input logic [2:0] top,
    input string      label
);
    @(negedge clk);
    a = ta; b = tb; op = top;
    @(posedge clk);   // clock latches the input
    @(posedge clk);   // ← wait ONE more cycle for output FF to update
    #1;
    $display("[%s] t=%0t | op=%03b a=%02h b=%02h => result=%02h | C=%b Z=%b OVF=%b N=%b",
             label, $time, op, a, b, result, carry, zero, overflow, negative);
endtask

    // ---------------------------------------------------
    // Stimulus
    // ---------------------------------------------------
    initial begin
    rst_n = 1'b0;
    te    = 1'b0;
    a     = 8'h00;
    b     = 8'h00;
    op    = 3'b000;

    repeat(2) @(posedge clk);
    #3 rst_n = 1'b1;
    @(posedge clk);

    // ---- Arithmetic ops (op[2]=0) ----
    apply_op(8'h0F, 8'h01, 3'b000, "ADD  0F+01=10      ");
    apply_op(8'hFF, 8'h01, 3'b000, "ADD  FF+01 carry=1 ");
    apply_op(8'h50, 8'h20, 3'b001, "SUB  50-20=30      ");
    apply_op(8'h00, 8'h01, 3'b001, "SUB  00-01 borrow  ");
    apply_op(8'h05, 8'h00, 3'b010, "INC  05->06        ");
    apply_op(8'hFF, 8'h00, 3'b010, "INC  FF->00 carry  ");
    apply_op(8'h01, 8'h00, 3'b011, "DEC  01->00        ");
    apply_op(8'h00, 8'h00, 3'b011, "DEC  00->FF borrow ");

    // ---- ONE IDLE CYCLE before switching to logic ----
    @(posedge clk); #2;

    // ---- Logic ops (op[2]=1) ----
    apply_op(8'hAA, 8'h0F, 3'b100, "AND  AA&0F=0A      ");
    apply_op(8'hA0, 8'h0F, 3'b101, "OR   A0|0F=AF      ");
    apply_op(8'hFF, 8'hAA, 3'b110, "XOR  FF^AA=55      ");
    apply_op(8'hA5, 8'h00, 3'b111, "NOT  ~A5=5A        ");

    // ---- Flag corner cases ----
    apply_op(8'h07, 8'h07, 3'b001, "SUB  07-07 zero=1  ");
    apply_op(8'h80, 8'h01, 3'b000, "ADD  80+01 neg=1   ");
    apply_op(8'h7F, 8'h01, 3'b000, "ADD  7F+01 ovf=1   ");

    repeat(3) @(posedge clk);
    $display("\n=== Simulation complete ===");
    $finish;
    end
    // ---------------------------------------------------
    // Timeout watchdog (500 ns max)
    // ---------------------------------------------------
    initial begin
        #500;
        $display("TIMEOUT: simulation exceeded 500 ns");
        $finish;
    end

endmodule