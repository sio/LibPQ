// TODO: docstring, review, save


(table as table, key_field as text, optional dupe_field as text) =>
let
    DupeField = if dupe_field is null then "Duplicate.Count" else dupe_field,
    DupeDelimiter = ".",
    DupeName =
        if
            Text.Contains(DupeField, ".")
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
