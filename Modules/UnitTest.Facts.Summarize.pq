/**
Run tests represented as a list of facts.

This is a part of compatibility layer between LibPQ and Microsoft's framework
for unit testing in Power Query

More information: https://docs.microsoft.com/en-us/power-query/handlingunittesting
**/

(facts as list) =>
let
    UnitTest.Run = LibPQ("UnitTest.Run"),
    Assert = LibPQ("UnitTest.Assert"),
    Config = LibPQ("UnitTest.Constants"),

    Tests = List.Accumulate(
        facts,
        [],
        (collection, fact) =>
            Record.AddField(
                collection,
                Config[Test.Prefix] & " - " & fact[name],
                Assert[Equal](fact[expected], fact[actual])
            )
    ),
    Result = UnitTest.Run(Tests)
in
    Result
