`timescale 1ns/1ps

module fifo_tb;

////////////////////////////////////////////////////////////
// Parameters
////////////////////////////////////////////////////////////

parameter DATA_WIDTH = 8;
parameter DEPTH      = 16;
parameter ADDR_WIDTH = $clog2(DEPTH);

////////////////////////////////////////////////////////////
// DUT Signals
////////////////////////////////////////////////////////////

logic clk;
logic rst_n;

logic wr_en;
logic rd_en;

logic [DATA_WIDTH-1:0] din;
logic [DATA_WIDTH-1:0] dout;

logic full;
logic empty;

logic almost_full;
logic almost_empty;

logic [ADDR_WIDTH:0] count;

////////////////////////////////////////////////////////////
// DUT
////////////////////////////////////////////////////////////

fifo #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)
dut
(
    .clk(clk),
    .rst_n(rst_n),

    .wr_en(wr_en),
    .rd_en(rd_en),

    .din(din),
    .dout(dout),

    .full(full),
    .empty(empty),

    .almost_full(almost_full),
    .almost_empty(almost_empty),

    .count(count)
);

////////////////////////////////////////////////////////////
// Clock Generation
////////////////////////////////////////////////////////////

initial
    clk = 0;

always #5 clk = ~clk;

////////////////////////////////////////////////////////////
// Include Files
////////////////////////////////////////////////////////////

`include "fifo_utils.svh"
`include "fifo_scoreboard.svh"
`include "fifo_driver.svh"
`include "fifo_tests.svh"

////////////////////////////////////////////////////////////
// Main Test
////////////////////////////////////////////////////////////

initial
begin

    //----------------------------------------------------
    // Initialize
    //----------------------------------------------------

    rst_n = 1'b1;

    wr_en = 0;
    rd_en = 0;

    din   = '0;

    //----------------------------------------------------
    // Banner
    //----------------------------------------------------

    banner();

    //----------------------------------------------------
    // Run Testcases
    //----------------------------------------------------

    test_reset();

    test_single_write_read();

    test_fill_fifo();

    test_empty_fifo();

    test_overflow();

    test_underflow();

    test_simultaneous_rw();

    test_random();

    //----------------------------------------------------
    // Summary
    //----------------------------------------------------

    summary();

    #20;

    $finish;

end

endmodule