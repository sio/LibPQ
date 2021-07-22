/**
Unit tests for Web.CbrCurrencyRates
**/
[
    Web.CbrCurrencyRates = LibPQ("Web.CbrCurrencyRates"),

    testLongDateRange = Assert[Equal](
        Table.RowCount(
            Web.CbrCurrencyRates("USD", #date(2019,1,1), #date(2021,1,15))
        ),
        494
    ),

    testSpecificValue = Assert[Equal](
        Web.CbrCurrencyRates("EUR", #date(2020,2,1), #date(2020,2,1))[curs]{0},
        69.5976
    ),

    testSpecificValueFromRange = Assert[Equal](
        Web.CbrCurrencyRates("EUR", #date(2020,2,1), #date(2020,5,1))[curs]{26}, // 12.03.2020
        81.0207
    ),

    /** Import assertion functions **/
    UnitTest.Subtests = LibPQ("UnitTest.Subtests"),
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
