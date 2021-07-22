/**
Unit tests for Web.CbrCurrencyRates
**/
[
    Web.CbrCurrencyRates = LibPQ("Web.CbrCurrencyRates"),

    testLongDateRange = Assert[Equal](
        Table.RowCount(
            Web.CbrCurrencyRates("USD", "01.01.2019", "15.01.2021")
        ),
        494
    ),

    testSpecificValue = Assert[Equal](
        Web.CbrCurrencyRates("EUR", "01.02.2020", "01.02.2020")[curs]{0},
        69.5976
    ),

    testSpecificValueFromRange = Assert[Equal](
        Web.CbrCurrencyRates("EUR", "01.02.2020", "01.05.2020")[curs]{26}, // 12.03.2020
        81.0207
    ),

    /** Import assertion functions **/
    UnitTest.Subtests = LibPQ("UnitTest.Subtests"),
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
