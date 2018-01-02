/**
Run tests from the test suite referenced by its module name

Return a table of test results
**/
(suite_name as text) =>
let
    Suite = LibPQ(suite_name),

    /* Load constants */
    UnitTest.Assert = LibPQ("UnitTest.Assert"),
    Error.Reason = UnitTest.Assert[Error.Reason],
    Test.Prefix = UnitTest.Assert[Test.Prefix],

    /* Analyze test triage result */
    Test.ReadStatus = (try_result) =>
    let
        Success = not try_result[HasError],
        Failure =
            try
                try_result[Error][Reason] = Error.Reason
            otherwise
                false,
        Error = try_result[Error],
        Return =
            if Success
            then {"PASSED", ""}
            else if Failure
            then {"FAILED", Error[Reason] & ": " & Error[Message]}
            else {"ERROR",  Error[Reason] & ": " & Error[Message]}
    in
        Return,

    /* Detect test functions */
    Test.Names = List.Select(
        Record.FieldNames(Suite),
        each Text.StartsWith(_, Test.Prefix)
    ),
    Test.Table = Table.FromColumns({Test.Names},{"Test"}),

    /* Execute all tests in the suite */
    Column.Factories = {
        {"Result", each try Record.Field(Suite, [Test])()},
        {"Temp", each Test.ReadStatus([Result])},
        {"Status", each [Temp]{0}},
        {"Description", each [Temp]{1}}
    },
    Test.Extra = List.Last(List.Generate(
        () => [i = -1, table = Test.Table],
        each [i] < List.Count(Column.Factories),
        each [
            i = [i] + 1,
            table = Table.AddColumn(
                [table],
                Column.Factories{i}{0},
                Column.Factories{i}{1}
            )
        ],
        each [table]
    )),
    Return = Table.RemoveColumns(Test.Extra, "Temp")
in
    Return
