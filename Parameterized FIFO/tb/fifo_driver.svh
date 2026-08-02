////////////////////////////////////////////////////////////
// FIFO DRIVER
////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////
// RESET
////////////////////////////////////////////////////////////

task automatic driver_reset();

begin

    rst_n = 0;

    wr_en = 0;
    rd_en = 0;
    din   = '0;

    repeat(5) @(posedge clk);

    rst_n = 1;

    repeat(2) @(posedge clk);

end

endtask

////////////////////////////////////////////////////////////
// WRITE
////////////////////////////////////////////////////////////

task automatic driver_write
(
    input logic [DATA_WIDTH-1:0] data
);

begin

    while(full)
        @(posedge clk);

    @(negedge clk);

    din   = data;
    wr_en = 1;
    rd_en = 0;

    @(posedge clk);

    @(negedge clk);

    wr_en = 0;

end

endtask

////////////////////////////////////////////////////////////
// READ
////////////////////////////////////////////////////////////

task automatic driver_read
(
    output logic [DATA_WIDTH-1:0] data
);

begin

    while(empty)
        @(posedge clk);

    @(negedge clk);

    wr_en = 0;
    rd_en = 1;

    @(posedge clk);

    // Registered output
    #1;
    data = dout;

    @(negedge clk);

    rd_en = 0;

end

endtask

////////////////////////////////////////////////////////////
// SIMULTANEOUS READ/WRITE
////////////////////////////////////////////////////////////

task automatic driver_rw
(
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic [DATA_WIDTH-1:0] rd_data
);

begin

    while(full || empty)
        @(posedge clk);

    @(negedge clk);

    din   = wr_data;
    wr_en = 1;
    rd_en = 1;

    @(posedge clk);

    // Wait for registered output
    #1;
    rd_data = dout;

    @(negedge clk);

    wr_en = 0;
    rd_en = 0;

end

endtask

////////////////////////////////////////////////////////////
// WRITE TRANSACTION
////////////////////////////////////////////////////////////

task automatic write_transaction
(
    input logic [DATA_WIDTH-1:0] data
);

begin

    driver_write(data);

    sb_push(data);

    sb_check_count();

    sb_check_flags();

end

endtask

////////////////////////////////////////////////////////////
// READ TRANSACTION
////////////////////////////////////////////////////////////

task automatic read_transaction
(
    output logic [DATA_WIDTH-1:0] data
);

begin

    driver_read(data);

    sb_check(data);

end

endtask

////////////////////////////////////////////////////////////
// READ + WRITE TRANSACTION
////////////////////////////////////////////////////////////

task automatic rw_transaction
(
    input  logic [DATA_WIDTH-1:0] wr_data,
    output logic [DATA_WIDTH-1:0] rd_data
);

begin

    driver_rw(wr_data, rd_data);

    // Compare the value read
    sb_check_data(rd_data);

    // Add newly written data
    sb_push(wr_data);

    // Now counts and flags match the DUT
    sb_check_count();

    sb_check_flags();

end

endtask