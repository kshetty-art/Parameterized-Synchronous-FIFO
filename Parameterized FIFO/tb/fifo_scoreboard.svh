////////////////////////////////////////////////////////////
// FIFO SCOREBOARD
////////////////////////////////////////////////////////////

logic [DATA_WIDTH-1:0] exp_q[$];
logic [DATA_WIDTH-1:0] expected_data;

bit sb_error;

////////////////////////////////////////////////////////////
// RESET SCOREBOARD
////////////////////////////////////////////////////////////

task automatic sb_reset();

begin

    exp_q.delete();

    sb_error = 0;

end

endtask

////////////////////////////////////////////////////////////
// PUSH EXPECTED DATA
////////////////////////////////////////////////////////////

task automatic sb_push
(
    input logic [DATA_WIDTH-1:0] data
);

begin

    exp_q.push_back(data);

end

endtask

////////////////////////////////////////////////////////////
// CHECK READ DATA
////////////////////////////////////////////////////////////

task automatic sb_check_data
(
    input logic [DATA_WIDTH-1:0] actual
);

begin

    if(exp_q.size()==0)
    begin

        sb_error = 1;

        $display("------------------------------------------");
        $display("SCOREBOARD ERROR");
        $display("Queue Empty");
        $display("------------------------------------------");

    end

    else
    begin

        expected_data = exp_q.pop_front();

        if(expected_data !== actual)
        begin

            sb_error = 1;

            $display("------------------------------------------");
            $display("DATA MISMATCH");
            $display("Expected : %02h", expected_data);
            $display("Actual   : %02h", actual);
            $display("------------------------------------------");

        end

    end

end

endtask

////////////////////////////////////////////////////////////
// CHECK COUNT
////////////////////////////////////////////////////////////

task automatic sb_check_count();

integer expected_count;

begin

    expected_count = exp_q.size();

    if(count !== expected_count)
    begin

        sb_error = 1;

        $display("------------------------------------------");
        $display("COUNT ERROR");
        $display("Expected Count : %0d", expected_count);
        $display("Actual Count   : %0d", count);
        $display("------------------------------------------");

    end

end

endtask

////////////////////////////////////////////////////////////
// CHECK FLAGS
////////////////////////////////////////////////////////////

task automatic sb_check_flags();

begin

    //---------------- Empty ----------------

    if(empty !== (exp_q.size()==0))
    begin

        sb_error = 1;

        $display("------------------------------------------");
        $display("EMPTY FLAG ERROR");
        $display("------------------------------------------");

    end

    //---------------- Full ----------------

    if(full !== (exp_q.size()==DEPTH))
    begin

        sb_error = 1;

        $display("------------------------------------------");
        $display("FULL FLAG ERROR");
        $display("------------------------------------------");

    end

    //---------------- Almost Empty ----------------

    if(almost_empty !== (exp_q.size()<=1))
    begin

        sb_error = 1;

        $display("------------------------------------------");
        $display("ALMOST EMPTY FLAG ERROR");
        $display("------------------------------------------");

    end

    //---------------- Almost Full ----------------

    if(almost_full !== (exp_q.size()>=DEPTH-1))
    begin

        sb_error = 1;

        $display("------------------------------------------");
        $display("ALMOST FULL FLAG ERROR");
        $display("------------------------------------------");

    end

end

endtask

////////////////////////////////////////////////////////////
// COMPLETE CHECK
////////////////////////////////////////////////////////////

task automatic sb_check
(
    input logic [DATA_WIDTH-1:0] actual
);

begin

    sb_check_data(actual);

    sb_check_count();

    sb_check_flags();

end

endtask