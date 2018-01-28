/**
Add a column to a table that will show the number of rows that contain the
same value of key_field as the current row.

Optional dupe_field is the name of the new column, by default
"Duplicate.Count". dupe_field has to contain a "." character, because it's
used as a delimiter by Table.PrefixColumns.
**/


(table as table, key_field as text, optional dupe_field as text) =>
let
    DupeField = if dupe_field is null then "Duplicate.Count" else dupe_field,
    DupeDelimiter = ".",
    DupeName =
        if
            Text.Contains(DupeField, DupeDelimiter)
        then
            [
                prefix = Text.BeforeDelimiter(DupeField, DupeDelimiter, 0),
                postfix = Text.AfterDelimiter(DupeField, DupeDelimiter, 0)
            ]
        else
            error "dupe_field has to contain a delimiter: " & DupeDelimiter,

    DuplicateCount =
        Table.PrefixColumns(
            Table.Group(
                table,
                {key_field},
                {{DupeName[postfix], each Table.RowCount(_), type number}}
            ),
            DupeName[prefix]
        ),

    Return =
        Table.RemoveColumns(
            Table.Join(
                table,
                key_field,
                DuplicateCount,
                DupeName[prefix] & "." & key_field,
                JoinKind.LeftOuter
            ),
            DupeName[prefix] & "." & key_field
        )
in
    Return
