////////////////////////////////////////////////////////////
// FIFO Utilities
////////////////////////////////////////////////////////////

integer total_tests  = 0;
integer passed_tests = 0;
integer failed_tests = 0;

////////////////////////////////////////////////////////////
// Banner
////////////////////////////////////////////////////////////

task automatic banner();

begin

    $display("");
    $display("=======================================================");
    $display("      PARAMETERIZED SYNCHRONOUS FIFO VERIFICATION");
    $display("=======================================================");
    $display("");

end

endtask

////////////////////////////////////////////////////////////
// Display Testcase Name
////////////////////////////////////////////////////////////

task automatic testcase
(
    input integer tc_num,
    input string  tc_name
);

begin

    total_tests++;

    $display("");
    $display("-------------------------------------------------------");
    $display("TESTCASE %0d : %s", tc_num, tc_name);
    $display("-------------------------------------------------------");

end

endtask

////////////////////////////////////////////////////////////
// PASS
////////////////////////////////////////////////////////////

task automatic pass();

begin

    passed_tests++;

    $display("STATUS : PASS");

end

endtask

////////////////////////////////////////////////////////////
// FAIL
////////////////////////////////////////////////////////////

task automatic fail();

begin

    failed_tests++;

    $display("STATUS : FAIL");

end

endtask

////////////////////////////////////////////////////////////
// Final Summary
////////////////////////////////////////////////////////////

task automatic summary();

begin

    $display("");
    $display("=======================================================");
    $display("                FINAL REPORT");
    $display("=======================================================");
    $display("TOTAL TESTS : %0d", total_tests);
    $display("PASSED      : %0d", passed_tests);
    $display("FAILED      : %0d", failed_tests);

    if(failed_tests == 0)
    begin
        $display("");
        $display("************* ALL TESTS PASSED *************");
    end
    else
    begin
        $display("");
        $display("************* SOME TESTS FAILED ************");
    end

    $display("=======================================================");
    $display("");

end

endtask