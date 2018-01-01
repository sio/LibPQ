/**
Run tests from the test suite referenced by its module name
**/
(suite_name as text) =>
let
    Suite = LibPQ(suite_name),

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


    Test.Names = List.Select(
        Record.FieldNames(Suite),
        each Text.StartsWith(_, Test.Prefix)
    ),
    Test.Table = Table.FromColumns({Test.Names},{"Name"}),
//    Test.Results = Table.AddColumn(
//        Test.Table,
//        "Result",
//        each try Record.Field(Suite, [Name])()
//    ),
//    Test.Statuses = Table.AddColumn(
//        Test.Results,
//        "Status.Temp",
//        each Test.ReadStatus([Result])
//    ),
    Column.Factories = {
        {"Result", each try Record.Field(Suite, [Name])()},
        {"Status.Temp", each Test.ReadStatus([Result])}
        // TODO: split temp into two columns
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
    Return = Test.Extra
in
    Return
