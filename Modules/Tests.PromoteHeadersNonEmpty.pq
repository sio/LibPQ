/**
Unit tests for Table.PromoteHeadersNonEmpty
**/

[
    Table.PromoteHeadersNonEmpty = LibPQ("Table.PromoteHeadersNonEmpty"),
    UnitTest.Subtests = LibPQ("UnitTest.Subtests"),

    Input = #table(
        {"foo","bar","baz"},
        {
            {"hello","",null},
            {"","world",0},
            {"",null,"LibPQ"},
            {10,20,123}
        }
    ),
    Headers = {
        {"hello", "bar", "baz"},
        {"hello", "world", "baz"},
        {"hello", "world", "LibPQ"},
        {"10","20","123"}
    },
    Runs = List.Skip(
        List.Generate(
            () => [
                i = -1,
                header = null,
                table = Input
            ],
            each [i] < List.Count(Headers),
            each [
                i = [i] + 1,
                header = Table.ColumnNames(table),
                table = Table.PromoteHeadersNonEmpty([table])
            ],
            each [header]
        ),
        1
    ),

    testCorrectHeaders = UnitTest.Subtests(
        (calculated, correct) => () => Assert[Equal](calculated, correct),
        List.Zip({Headers, Runs})
    ),

    BadInput = #table(
        {"foo","bar","baz"},
        {
            {0,0,{1,2,3}}
        }
    ),
    testBadInput = () =>
        Assert[Raises](
            () => Table.PromoteHeadersNonEmpty(BadInput),
            "Expression.Error"
        ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
