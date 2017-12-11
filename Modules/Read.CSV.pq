/**
Read.CSV:
    Load arbitrary CSV file with unknown number of columns (up to 1000)
    and unknown number of extra lines before the column names (first column name
    has to be known).

    Note: If last column name starts with underscore or is empty, please specify
          it in the parameters or that column will be lost.
**/

(tsv_path,
first_column_header,
optional encoding,
optional delimiter as text,
optional lastcolumn_name as text) =>
let

    /* Default parameter values */
    Delimiter = if delimiter is null then "#(tab)" else delimiter,
    Encoding = if encoding is null then 65001 else encoding,

    /* Load CSV */
    Source = Csv.Document(
                File.Contents(tsv_path),
                [
                    Delimiter=Delimiter,
                    Columns=1000,
                    Encoding=Encoding,
                    QuoteStyle=QuoteStyle.None
                ]),
    Skipped = Table.RemoveFirstN(
                Source,
                each [Column1] <> first_column_header),
    WithHeaders = Table.PromoteHeaders(Skipped, [PromoteAllScalars=true]),
    ValidColumns = List.Reverse(
        List.Skip(
            List.Reverse(Table.ColumnNames(WithHeaders)),
            each (_ = "" or Text.StartsWith(_, "_")) and _ <> lastcolumn_name
        )
    ),
    Result = Table.SelectColumns(WithHeaders, ValidColumns)
in
    Result
