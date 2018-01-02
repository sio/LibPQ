/**
Run tests from the test suite that may be passed as a record with test
functions or may be referenced by its module name

Return a table of test results
**/
(suite_name as nullable text, optional suite) =>
let
    Suite = if suite = null then LibPQ(suite_name) else suite,

    /* Load constants */
    Config = LibPQ("UnitTest.Constants"),
    Error.Reason = Config[Error.Reason],
    Test.Prefix = Config[Test.Prefix],

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
