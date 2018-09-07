/**
Unit tests for Function.Chain
**/
[
    Function.Chain = LibPQ("Function.Chain"),

    /* Sequence of arithmetic operations */
    SampleSeed = 33,
    SampleOps = {
        each _ + 1,
        each _ - 10,
        each _ + 18
    },
    CorrectAnswer = 42,

    testPipeOK = Assert[Equal](
        Function.Chain(SampleSeed, SampleOps),
        CorrectAnswer
    ),
    testPipeFail = Assert[NotEqual](
        Function.Chain(SampleSeed, SampleOps),
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
        Function.Chain(StringSeed, StringOps),
        StringAnswer
    ),
    testStringFail = Assert[NotEqual](
        Function.Chain(StringSeed, StringOps),
        "Hello World"
    ),

    /* Debug mode has to return the same output */
    DebugAnswer = Function.Chain(SampleSeed, SampleOps, "debug"),
    testDebugValue = Assert[Equal](
        List.Last(DebugAnswer[Result]),
        CorrectAnswer
    ),
    testDebugCount = Assert[Equal](
        List.Count(DebugAnswer[Result]),
        List.Count(SampleOps) + 1
    ),

    RandomInputs = List.Random(10),
    testRandomInputs = UnitTest.Subtests(
        Assert[Equal],
        List.Transform(
            RandomInputs,
            each {
                // Compare results from debug and non-debug mode
                Function.Chain(_, SampleOps),
                List.Last(Function.Chain(_, SampleOps, "debug")[Result])
            }
        )
    ),

    /** Import assertion functions **/
    UnitTest.Subtests = LibPQ("UnitTest.Subtests"),
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
