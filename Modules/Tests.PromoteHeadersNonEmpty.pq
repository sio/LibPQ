/**
Unit tests for Table.PromoteHeadersNonEmpty
**/

[
    Table.PromoteHeadersNonEmpty = LibPQ("Table.PromoteHeadersNonEmpty"),

    Input = #table(
        {"foo","bar","baz"},
        {
            {"hello","",null},
            {"","world",0},
            {"",null,"LibPQ"}
        }
    ),
    Headers = [
        First = {"hello", "bar", "baz"},
        Second = {"hello", "world", "baz"},
        Third = {"hello", "world", "LibPQ"}
    ],
    Runs = [
        First = Table.PromoteHeadersNonEmpty(Input),
        Second = Table.PromoteHeadersNonEmpty(First),
        Third = Table.PromoteHeadersNonEmpty(Second)
    ],

    testFirstInvocation = () =>
        Assert[Equal](
            Table.ColumnNames(Runs[First]),
            Headers[First]
        ),
    testSecondInvocation = () =>
        Assert[Equal](
            Table.ColumnNames(Runs[Second]),
            Headers[Second]
        ),
    testThirdInvocation = () =>
        Assert[Equal](
            Table.ColumnNames(Runs[Third]),
            Headers[Third]
        ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
