/**
Constants for LibPQ UnitTest framework
**/
[
    /* Default error reason for failed tests */
    Error.Reason = "LibPQ.AssertionError",

    /* All tests have to be stored in fields which names start with the prefix */
    Test.Prefix = "test",

    /* Metadata field that indicates the record is LibPQ test suite */
    Suite.MetaField = "LibPQ.TestSuite",
    Suite.Runners = [
        // [test suite version : test runner module name]
        //
        // Test runner is a function that takes one argument (test suite),
        // runs it and returns test results as a table structured the same as
        // the output of UnitTest.Run (reference test runner)
        1 = "UnitTest.Run",
        Facts = "UnitTest.Facts.Summarize"
    ]
]
