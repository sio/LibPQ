/**
Unit tests for Table.NumberColumns
**/

[
    Table.NumberColumns = LibPQ("Table.NumberColumns"),

    Input = #table(
        {"foo","bar","baz"},
        {
            {"1","2",null},
            {"4","5",""},
            {"7","8",0}
        }
    ),
    BadInput = #table(
        {"foo","bar","baz"},
        {
            {"4","5","hello"}
        }
    ),
    Output =  #table(
        {"foo","bar","baz"},
        {
            {1,2,0},
            {4,5,0},
            {7,8,0}
        }
    ),

    testTransormation = () =>
        Assert[Equal](
            Table.NumberColumns(Input, Table.ColumnNames(Input)),
            Output
        ),

    testInvalidInput = () =>
        Assert[True](
            Table.NumberColumns(BadInput, Table.ColumnNames(BadInput)) <> null
        ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
