let
    Filename = fnReadParameters("ПапкаВыгрузки") & "\ERP.txt",
    Imported = fnImportCSV(Filename, "Ссылка"),
    KeyField = "Код",
    DuplicatePrefix = "Duplicate",

    /* Count duplicates in KeyField */
    DuplicateCount =
        Table.PrefixColumns(
            Table.Group(
                Imported,
                {KeyField},
                {{"Count", each Table.RowCount(_), type number}}
            ),
            DuplicatePrefix
        ),
    Return =
        Table.RemoveColumns(
            Table.Join(
                Imported,
                KeyField,
                DuplicateCount,
                DuplicatePrefix & "." & KeyField,
                JoinKind.LeftOuter
            ),
            DuplicatePrefix & "." & KeyField
        )
in
    Return