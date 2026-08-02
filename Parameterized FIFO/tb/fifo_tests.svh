////////////////////////////////////////////////////////////
// TESTCASE 1 : RESET
////////////////////////////////////////////////////////////

task automatic test_reset();

begin

    testcase(1,"RESET");

    driver_reset();
    sb_reset();

    if(empty && !full && count==0)
        pass();
    else
        fail();

end

endtask

////////////////////////////////////////////////////////////
// TESTCASE 2 : SINGLE WRITE READ
////////////////////////////////////////////////////////////

task automatic test_single_write_read();

logic [DATA_WIDTH-1:0] rd_data;

begin

    testcase(2,"SINGLE WRITE READ");

    driver_reset();
    sb_reset();

    write_transaction(8'hAA);

    read_transaction(rd_data);

    if(sb_error==0)
        pass();
    else
        fail();

end

endtask

////////////////////////////////////////////////////////////
// TESTCASE 3 : FILL FIFO
////////////////////////////////////////////////////////////

task automatic test_fill_fifo();

integer i;

begin

    testcase(3,"FILL FIFO");

    driver_reset();
    sb_reset();

    for(i=0;i<DEPTH;i++)
        write_transaction(i);

    if(sb_error==0 && full)
        pass();
    else
        fail();

end

endtask

////////////////////////////////////////////////////////////
// TESTCASE 4 : EMPTY FIFO
////////////////////////////////////////////////////////////

task automatic test_empty_fifo();

logic [DATA_WIDTH-1:0] rd_data;
integer i;

begin

    testcase(4,"EMPTY FIFO");

    driver_reset();
    sb_reset();

    // Fill FIFO
    for(i=0;i<DEPTH;i++)
        write_transaction(i);

    // Empty FIFO
    for(i=0;i<DEPTH;i++)
        read_transaction(rd_data);

    if(sb_error==0 && empty)
        pass();
    else
        fail();

end

endtask

////////////////////////////////////////////////////////////
// TESTCASE 5 : OVERFLOW
////////////////////////////////////////////////////////////

task automatic test_overflow();

logic [DATA_WIDTH-1:0] wr_data;
integer i;

begin

    testcase(5,"OVERFLOW");

    driver_reset();
    sb_reset();

    // Fill FIFO
    for(i=0;i<DEPTH;i++)
        write_transaction(i);

    // Illegal Writes
    repeat(5)
    begin
        wr_data = $urandom;
        driver_write(wr_data);
    end

    sb_check_count();
    sb_check_flags();

    if(sb_error==0)
        pass();
    else
        fail();

end

endtask

////////////////////////////////////////////////////////////
// TESTCASE 6 : UNDERFLOW
////////////////////////////////////////////////////////////

task automatic test_underflow();

logic [DATA_WIDTH-1:0] rd_data;
integer i;

begin

    testcase(6,"UNDERFLOW");

    driver_reset();
    sb_reset();

    // Fill FIFO
    for(i=0;i<DEPTH;i++)
        write_transaction(i);

    // Empty FIFO
    for(i=0;i<DEPTH;i++)
        read_transaction(rd_data);

    // Illegal Reads
    repeat(5)
    begin
        rd_en = 1;
        @(posedge clk);
        #1;
        rd_en = 0;
    end

    sb_check_count();
    sb_check_flags();

    if(sb_error==0)
        pass();
    else
        fail();

end

endtask

////////////////////////////////////////////////////////////
// TESTCASE 7 : SIMULTANEOUS READ WRITE
////////////////////////////////////////////////////////////

task automatic test_simultaneous_rw();

logic [DATA_WIDTH-1:0] wr_data;
logic [DATA_WIDTH-1:0] rd_data;
integer i;

begin

    testcase(7,"SIMULTANEOUS RW");

    driver_reset();
    sb_reset();

    // Preload FIFO
    for(i=0;i<8;i++)
        write_transaction(i);

    repeat(20)
    begin

        wr_data = $urandom;

        rw_transaction(wr_data,rd_data);

    end

    if(sb_error==0)
        pass();
    else
        fail();

end

endtask

////////////////////////////////////////////////////////////
// TESTCASE 8 : RANDOM
////////////////////////////////////////////////////////////

task automatic test_random();

logic [DATA_WIDTH-1:0] wr_data;
logic [DATA_WIDTH-1:0] rd_data;

integer i;
integer op;

begin

    testcase(8,"RANDOM");

    driver_reset();
    sb_reset();

    repeat(1000)
    begin

        op = $urandom_range(0,2);

        case(op)

        //----------------------------------------
        // WRITE
        //----------------------------------------

        0:
        begin
            if(!full)
            begin
                wr_data = $urandom;
                write_transaction(wr_data);
            end
        end

        //----------------------------------------
        // READ
        //----------------------------------------

        1:
        begin
            if(!empty)
                read_transaction(rd_data);
        end

        //----------------------------------------
        // SIMULTANEOUS
        //----------------------------------------

        2:
        begin
            if(!full && !empty)
            begin
                wr_data = $urandom;
                rw_transaction(wr_data,rd_data);
            end
        end

        endcase

    end

    sb_check_count();
    sb_check_flags();

    if(sb_error==0)
        pass();
    else
        fail();

end

endtask