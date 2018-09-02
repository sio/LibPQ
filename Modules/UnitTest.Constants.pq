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
        1 = "UnitTest.Run",
        Facts = "UnitTest.Facts.Summarize"
    ]
]
