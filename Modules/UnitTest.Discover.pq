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
                ) otherwise if LooksLikeSuiteWithError([Name], [Value])
                then
                    ErrorSuiteMarker
                else
                    null
        ),
        each [SuiteVersion] <> null
    ),
    LooksLikeSuiteWithError = (name, object) =>
        let
            ModuleFilename = object[Detail][LibPQ][LibPQ.Source], // error record is assumed
            Read.Text = LibPQ("Read.Text"),
            ModuleSource = Read.Text(ModuleFilename, true),
            ModuleIsTestSuite = Text.Contains(ModuleSource, Config[Suite.MetaField]),
            ObjLikeError =
                Value.Is(object, type record)
                and Record.FieldCount(object) = 3
                and Record.FieldNames(object) = {"Reason", "Message", "Detail"},
            Return = ObjLikeError and ModuleIsTestSuite // Order matters for short circuiting.
                                                        // ModuleIsTestSuite assumes that
                                                        // object is an error record
        in
            Return,
    PropagateErrors = (suite) =>
        #table(
            { "Test", "Result", "Status", "Description"},
            {{ null,   suite,   "ERROR",   suite[Reason] & ": " &suite[Message]}}
        ),
    ErrorSuiteMarker = "This looks like a test suite with invalid code",
    SuitesValid =
        if Table.IsEmpty(SuitesFilter)
        then error Error.Record("LibPQ.TestsNotFound", "No tests were found among local modules", null)
        else SuitesFilter,
    Suites = Table.RenameColumns(
        SuitesValid,
        List.Zip({
            Table.ColumnNames(SuitesValid),
            {"Suite", "Object", "Version"}
        })
    ),
    SuiteRunners =
        Record.AddField(
            Record.FromList(
                List.Transform(
                    Record.FieldValues(Config[Suite.Runners]),
                    each LibPQ(_)
                ),
                Record.FieldNames(Config[Suite.Runners])
            ),
            ErrorSuiteMarker,
            PropagateErrors
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
    LongResults =
        Table.ReplaceErrorValues(
            Table.RemoveColumns(Expanded, {"Object"}),
            {"Status", "ERROR"}
        ),
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
