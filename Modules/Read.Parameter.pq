/**
Fetch parameter value from a data table in current workbook.
Parameters must be stored in two column data table (key-value pairs).
**/

(parameter as text, optional tablename as text) => let
    /* Default table name */
    ParameterTable = if tablename is null then "Параметры" else tablename,

    /* Get parameter value */
    Source = Excel.CurrentWorkbook(){[Name=ParameterTable]}[Content],
    Transposed = Table.Transpose(Source),
    Headers = Table.PromoteHeaders(Transposed, [PromoteAllScalars=true])
in
    Table.Column(Headers, parameter){0}
