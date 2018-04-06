/**
Apply a sequence of operations to the input value. Input for each consecutive
operation is the output from the previous one.

Operations are to be provides as list of functions that take exactly one
argument and return exactly one value of the same type.

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
    Return = FastWay
in
    Return
