/**
fnImportCSV:
    Load arbitrary CSV file with unknown number of columns (up to 1000)
    and unknown number of extra lines before the column names (first column name
    has to be known).

    Note: Columns which names start with underscore ("_") will be lost, if
          there are any in the original CSV.
**/

(tsv_path, first_column_header, optional encoding, optional delimiter) => let

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
    ValidColumns = List.Select(
                Table.ColumnNames(WithHeaders),
                each _ <> "" and not Text.StartsWith(_, "_")),
    Result = Table.SelectColumns(WithHeaders, ValidColumns)
in
    Result