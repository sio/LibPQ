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

    Tests = List.Accumulate(
        facts,
        [],
        (collection, fact) =>
            Record.AddField(
                collection,
                "test - " & fact[name],
                Assert[True](fact[expected] = fact[actual])
            )
    ),
    Result = UnitTest.Run(Tests)
in
    Result
