/**
Unit tests for Table.ConcatenateRows
**/

[
    Table.ConcatenateRows = LibPQ("Table.ConcatenateRows"),

    data = {1,0,2,0,3,0,0,4,5},
    headers = {"foo", "bar", "baz", "sid"},

    TableOneA = Table.FromColumns({data}, {headers{0}}),
    TableOneB = Table.FromColumns({data}, {headers{1}}),
    TableOneC = Table.FromColumns({data}, {headers{2}}),
    TableTwo   = Table.FromColumns({data, data}, List.FirstN(headers, 2)),
    TableThree = Table.FromColumns({data, data, data}, {headers{2}, headers{0}, headers{1}}),

    testTwoOneColumnTables =
        Assert[Equal](
            Table.ConcatenateRows(TableOneA, TableOneB),
            TableTwo
        ),

    testOneColumnAndTwoColumnCombined =
        Assert[Equal](
            Table.ConcatenateRows(TableOneC, TableTwo),
            TableThree
        ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
