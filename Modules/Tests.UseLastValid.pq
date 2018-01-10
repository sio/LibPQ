/**
Unit tests for List.UseLastValid and Table.UseLastValid
**/

[
    List.UseLastValid = LibPQ("List.UseLastValid"),
    Table.UseLastValid = LibPQ("Table.UseLastValid"),

    input  = {1,0,2,0,3,0,0,4,5},
    output = {1,1,2,2,3,3,3,4,5},

    testList = () =>
        Assert[Equal](
            List.UseLastValid(input, each _ > 0),
            output
        ),

    testTable = () =>
        Assert[Equal](
            Table.UseLastValid(
                Table.FromColumns({input}, {"Number"}),
                each [Number] > 0
            ),
            Table.FromColumns({output}, {"Number"})
        ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
