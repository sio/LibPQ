/**
Demo of LibPQ's compatibility with Microsoft's unit testing framework

https://docs.microsoft.com/en-us/power-query/handlingunittesting
**/

let
    Fact = LibPQ("UnitTest.Fact"),
    Facts.Summarize = LibPQ("UnitTest.Facts.Summarize"),

    UnitTesting.ReturnsABC = () => "ABC",
    UnitTesting.Returns123 = () => "123",
    UnitTesting.ReturnTableWithFiveRows = () => Table.Repeat(#table({"a"},{{1}}),5),

    facts =
    {
        Fact("Check that this function returns 'ABC'",
            "ABC",
            UnitTesting.ReturnsABC()
        ),
        Fact("Check that this function returns '123'",
            "123",
            UnitTesting.Returns123()
        ),
        Fact("Result should contain 5 rows",
            5,
            Table.RowCount(UnitTesting.ReturnTableWithFiveRows())
        ),
        Fact("Values should be equal (using a let statement)",
            "Hello World",
            let
                a = "Hello World"
            in
                a
        )
    }
in
    facts meta [LibPQ.TestSuite = "Facts"]
