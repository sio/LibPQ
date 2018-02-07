/**
Transform selected columns' type to number, replace null values with zeros
**/

// TODO
// - write unit tests
// - test non-number values

(table as table, columns as list) as table =>
let
    NumberTypes = List.Repeat({type number}, List.Count(columns)),
    DataWithTypes = Table.TransformColumnTypes(
        table,
        List.Zip({columns, NumberTypes})
    ),
    NumberNotNull = (number) => if number is null then 0 else number,
    DataNoNulls = Table.TransformColumns(
        DataWithTypes,
        List.Zip({
            columns,
            List.Repeat({NumberNotNull}, List.Count(columns)),
            NumberTypes
        })
    ),
    Return = DataNoNulls
in
    Return
