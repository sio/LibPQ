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
        Assert[False](
            (
                try Table.NumberColumns(BadInput, Table.ColumnNames(BadInput))
            )[HasError]
            // error will be stored in table cell, the table itself will be ok
        ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
