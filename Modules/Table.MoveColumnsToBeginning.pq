/**
Moves a list of columns of a given table to the beginning of that table.

Does the same thing as right-click column -> Move -> To Beginning in the GUI,
except that it does not hardcode the rest of the column names into the query.


Arguments:
table
    The table to transform
column_names
    A list of strings representing names of columns that are in the table

**/


(table as table, column_names as list) =>
    let
        NewColumns = column_names & List.RemoveItems(Table.ColumnNames(table), column_names),
        NewTable = Table.ReorderColumns(table, NewColumns)
    in
        NewTable
