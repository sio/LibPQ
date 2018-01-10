/**
Table.UseLastValid:
    Validate all rows in the input table and replace the invalid ones with the
    previous valid value.

    Arguments:
    input
        The table to transform
    validator
        A function that takes one argument (row record) and returns boolean value

    See also: List.UseLastValid
**/

(input as table, validator as function) =>
let
    Temp = [
        Index = "__Index__",
        Valid = "__Valid__",
        ValidIndex = "__ValidIndex__",
        Prefix = "__Prefix__"
    ],
    InputIndexed = Table.AddIndexColumn(input, Temp[Index], 0, 1),
    InputValidated = Table.AddColumn(InputIndexed, Temp[Valid], validator, type logical),
    IndexValid =
        // Table.ToRows is faster and uses less memory than List.Zip for two columns
        Table.ToRows(
            Table.SelectColumns(
                InputValidated,
                {Temp[Index], Temp[Valid]}
            )
        ),
    IndexValidator = each _{1},
    LastValidIndex = Table.TransformColumnTypes(
        Table.FromColumns(
            {List.Transform(
                List.UseLastValid(IndexValid, IndexValidator),
                each _{0}
            )},
            {Temp[ValidIndex]}
        ),
        {{Temp[ValidIndex], type number}}
    ),
    InputLinked = Table.ConcatenateRows(InputIndexed, LastValidIndex),
    InputPrefixed = Table.PrefixColumns(InputLinked, Temp[Prefix]),
    InputLastValid = Table.Join(
        InputPrefixed,
        Temp[Prefix] & "." & Temp[ValidIndex],
        InputIndexed,
        Temp[Index],
        JoinKind.LeftOuter
    ),
    Return = Table.RemoveColumns(
        InputLastValid,
        List.Intersect({
            Record.FieldValues(Temp) & Table.ColumnNames(InputPrefixed),
            Table.ColumnNames(InputLastValid)
        })
    )
in
    Return
