/**
Validate all items in the input list and replace the invalid ones with the
previous valid value.

Arguments:
input
    The list to transform
validator
    A function that takes one argument (list item) and returns boolean value

Example:
    List.UseLastValid({1,0,2,0,3,0,0,4,5}, each _ > 0)
    returns the list: {1,1,2,2,3,3,3,4,5}
**/

(input as list, validator as function) =>
let
    Return = List.Skip(
        List.Generate(
            () => [i=-1, value=input{0}],
            each [i] < List.Count(input),
            each [
                i = [i] + 1,
                value = if validator(input{i})
                        then input{i}
                        else [value]
            ],
            each [value]
        ),
        1
    )
in
    Return
