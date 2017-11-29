/**
fnMakeComparer:
    Factory for creating comparison functions to be used later
    for filling ErrorCheck columns
**/

(optional field1     as nullable text,
 optional field2     as nullable text,
 optional operator   as nullable text,
 optional expression as nullable text) => let

    /* Default parameter values */
    Operator = if operator is null then "=" else operator,

    /* Helper function that enables passing "null" as text */
    GetFieldOrNull = (record as record, field as text) =>
        if   field = "null"
        then null
        else Record.Field(record, field),

    /* New function generator */
    NewFunction = (record as record) => let
        Result =
            if      expression <> null
            then    Expression.Evaluate(
                        "(" & Text.Replace(expression, "[", "record[") & ")",
                        Record.AddField(#shared, "record", record)
                    )
            else if Operator = "=" or Operator = "=="
            then    GetFieldOrNull(record, field1) = GetFieldOrNull(record, field2)
            else if Operator = "<>" or Operator = "!="
            then    GetFieldOrNull(record, field1) <> GetFieldOrNull(record, field2)
            else    "Unknown comparison operator"
    in
        Result
in
    NewFunction