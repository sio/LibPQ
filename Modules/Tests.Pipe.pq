/**
Unit tests for Value.Pipe
**/
[
    Value.Pipe = LibPQ("Value.Pipe"),

    /* Sequence of arithmetic operations */
    SampleSeed = 33,
    SampleOps = {
        each _ + 1,
        each _ - 10,
        each _ + 18
    },
    CorrectAnswer = 42,

    testPipeOK = Assert[Equal](
        Value.Pipe(SampleSeed, SampleOps),
        CorrectAnswer
    ),
    testPipeFail = Assert[NotEqual](
        Value.Pipe(SampleSeed, SampleOps),
        CorrectAnswer + 1
    ),

    /* Same with strings */
    StringSeed = "foo",
    StringOps = {
        each _ & "PQ",
        each Text.Replace(_, "f", "L"),
        each Text.Replace(_, "oo", "ib")
    },
    StringAnswer = "LibPQ",

    testStringOK = Assert[Equal](
        Value.Pipe(StringSeed, StringOps),
        StringAnswer
    ),
    testStringFail = Assert[NotEqual](
        Value.Pipe(StringSeed, StringOps),
        "Hello World"
    ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
