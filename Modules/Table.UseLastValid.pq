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
    List.UseLastValid = LibPQ("List.UseLastValid"),
    // Table.ConcatenateRows = LibPQ("Table.ConcatenateRows"),
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
    /* Commenting out the following block */
    // LastValidIndex = Table.TransformColumnTypes(
        // Table.FromColumns(
            // {List.Transform(
                // List.UseLastValid(IndexValid, IndexValidator),
                // each _{0}
            // )},
            // {Temp[ValidIndex]}
        // ),
        // {{Temp[ValidIndex], type number}}
    // ),
    // InputLinked = Table.ConcatenateRows(InputIndexed, LastValidIndex),

    /* And replacing it with this */
    LastValidIndex =
        List.Transform(
            List.UseLastValid(IndexValid, IndexValidator),
            each _{0}
        ),
    InputLinked = Table.AddColumn(
        InputIndexed,
        Temp[ValidIndex],
        each LastValidIndex{Record.Field(_, Temp[Index])},
        type number
    ),

    /* Does not improve performance! */
    /*
     * I'm keeping this branch as a reminder that this was tried and this
     * failed.
     *
     * On my sample data the function from before branching out runs in 15
     * seconds, after adding these changes it runs much more slowly (I didn't
     * time the first attempt, the second one I've aborted after waiting for 2
     * minutes - and it still did not finish).
    */
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
