/**
Apply a sequence of operations to the input value. Input for each consecutive
operation is the output from the previous one.

Operations are to be provides as list of functions that take exactly one
argument and return exactly one value of the same type.

TODO: documentation!!!

Inspired by Imke Feldmann:
    http://www.thebiccountant.com/2017/08/16/should-we-pipe-m/
**/

/*
ImkeF implementation:
     (x, operations) =>
        List.Accumulate(
            operations,
            x,
            (state, current) =>
                Function.Invoke(current{0}, {state}&List.Skip(current))
        )

*/

(input as any, operations as list, optional debug as any) =>
let
    /*
    Pseudo code sketch:

    if
        debug is null
    then
        List.Accumulate
    else
        List.Generate + Fancy names function => table
    */
    FastWay = List.Accumulate(
        operations,
        input,
        (state, current) => Function.Invoke(current, {state})
    ),
    VerboseWay = List.Reverse(
        List.Accumulate(
            operations,
            {input},
            (state, current) => {Function.Invoke(current, {state{0}})} & state
        )
    ),
    VerboseResults = List.Skip(
        List.Generate(
            () => [
                i = -1,
                record = null
            ],
            each [i] < List.Count(VerboseWay),
            each [
                i = [i] + 1,
                record = [
                    Steps = "Step " & Text.From(i),
                    Result = VerboseWay{i}
                ]
            ],
            each [record]
        )
    ),

    Return = if debug is null then FastWay else Table.FromRecords(VerboseResults)
in
    Return
