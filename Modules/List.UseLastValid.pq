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
