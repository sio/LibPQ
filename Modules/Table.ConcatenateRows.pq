/**
Add all columns from tableB to tableA (with values)
**/

(tableA as table, tableB as table) =>
let
    IndexColumn = [
        A = "__IndexA__",
        B = "__IndexB__"
    ],
    Indexed = [
        A = Table.AddIndexColumn(tableA, IndexColumn[A], 0, 1),
        B = Table.AddIndexColumn(tableB, IndexColumn[B], 0, 1)
    ],
    Join = Table.Join(
        Indexed[A],
        IndexColumn[A],
        Indexed[B],
        IndexColumn[B],
        JoinKind.LeftOuter
    ),
    Return = Table.RemoveColumns(Join, Record.FieldValues(IndexColumn))
in
    Return
