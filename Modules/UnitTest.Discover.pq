/**
Discover and run tests from all local sources
**/
(optional compact_output as nullable logical) =>
let
    /* Default behavior is not yet decided upon and may be changed in future */
    Compact = if compact_output <> null then compact_output else true,

    Library = LibPQ(),
    Config = LibPQ("UnitTest.Constants"),
    UnitTest.Run = LibPQ("UnitTest.Run"),

    SuitesFilter = Table.SelectRows(
        Record.ToTable(Library),
        each (
            try
                Record.Field(
                    Value.Metadata([Value]),
                    Config[Suite.MetaField]
                )
            otherwise
                null
        ) = Config[Suite.MetaValue]
    ),
    Suites = Table.RenameColumns(
        SuitesFilter,
        List.Zip({
            Table.ColumnNames(SuitesFilter),
            {"Suite", "Object"}
        })
    ),
    Run = Table.AddColumn(Suites, "Results", each UnitTest.Run(null, [Object])),
    Expanded = Table.ExpandTableColumn(
        Run,
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
