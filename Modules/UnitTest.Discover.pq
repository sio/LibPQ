/**
Discover and run tests from all local sources
**/
let
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
    Run = Table.AddColumn(Suites, "Result", each UnitTest.Run(null, [Object])),
    Return = Run
in
    Return
