/**
Unit tests for Table.MoveColumnsToBeginning
**/

[
    Table.MoveColumnsToBeginning = LibPQ("Table.MoveColumnsToBeginning"),

    headers_before = {"foo", "bar", "baz", "bax"},
    data_before = {{1, 2}, {3, 4}, {5, 6}, {7, 8}},
    table_before = Table.FromColumns(data_before, headers_before),

    headers_after = {"bar", "baz", "foo", "bax"},
    data_after = {{3, 4}, {5, 6}, {1, 2}, {7, 8}},
    table_after = Table.FromColumns(data_after, headers_after),

    shifted_columns = Table.MoveColumnsToBeginning(table_before, {"bar", "baz"}),

    testCanMoveColumnsBefore =
        Assert[Equal](shifted_columns, table_after),

    // table equality test ignores order of columns so we need to check explicitly
    testColumnsInCorrectOrder =
        Assert[Equal](Table.ColumnNames(shifted_columns), headers_after),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
