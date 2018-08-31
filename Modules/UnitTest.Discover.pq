/**
Discover and run tests from all local sources.

Represent results as a table either grouped by status (compact_output = true)
or detailed with one row per each test (compact_output = false).
**/
(optional compact_output as nullable logical) =>
let
    /* Default behavior is not yet decided upon and may be changed in future */
    Compact = if compact_output <> null then compact_output else true,

    Library = LibPQ(),
    Config = LibPQ("UnitTest.Constants"),
    UnitTest.Run = LibPQ("UnitTest.Run"),

    SuitesFilter = Table.SelectRows(
        Table.AddColumn(
            Record.ToTable(Library),
            "SuiteVersion",
            each
                try Text.From(
                    Record.Field(
                        Value.Metadata([Value]),
                        Config[Suite.MetaField]
                    )
                ) otherwise
                    null
        ),
        each [SuiteVersion] <> null
    ),
    Suites = Table.RenameColumns(
        SuitesFilter,
        List.Zip({
            Table.ColumnNames(SuitesFilter),
            {"Suite", "Object", "Version"}
        })
    ),
    SuiteRunners = Record.FromList(
        List.Transform(
            Record.FieldValues(Config[Suite.Runners]),
            each LibPQ(_)
        ),
        Record.FieldNames(Config[Suite.Runners])
    ),
    Run = Table.AddColumn(
        Suites,
        "Results",
        each Record.Field(SuiteRunners, [Version])([Object])
    ),
    Expanded = Table.ExpandTableColumn(
        Table.RemoveColumns(Run, "Version"),
        "Results",
        Table.ColumnNames(Run[Results]{0})
    ),
    LongResults = Table.RemoveColumns(Expanded, {"Object"}),
    ShortResults = Table.Group(
        LongResults,
        {"Status"},
        {
            {"Count", each Table.RowCount(_), type number},
            {"Details", each _, type table}
        }
    ),
    ShortResultsSorted = Table.Sort(ShortResults, {{"Status", Order.Ascending}}),
    Return = if Compact then ShortResultsSorted else LongResults
in
    Return
