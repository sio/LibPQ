(field1 as text, field2 as text, optional operator as text) => let
    /*
    Factory for creating comparison functions to be used later
    for filling ErrorCheck columns
    */

    Operator = if operator is null then "=" else operator,
    GetFieldOrNull = (record as record, field as text) =>
        if   field = "null"
        then null
        else Record.Field(record, field),
    NewFunction = (record as record) => let
        Result =
            if      Operator = "=" or Operator = "=="
            then    GetFieldOrNull(record, field1) = GetFieldOrNull(record, field2)
            else if Operator = "<>" or Operator = "!="
            then    GetFieldOrNull(record, field1) <> GetFieldOrNull(record, field2)
            else    "Unknown comparison operator"
    in
        Result
in
    NewFunction