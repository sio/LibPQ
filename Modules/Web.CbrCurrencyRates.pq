/**
Fetch currency rates as published by The Central Bank of Russian Federation
at https://cbr.ru

Return table of currency rates by date

Arguments:

currency: Currency code (USD/EUR) or internal currency ID at cbr.ru

date_start: First value of the dates range.
            Date object, datetime object or string.

date_end: Last value of the dates range. If omitted, defaults to tomorrow.
**/

(currency as text, date_start, optional date_end) =>
let
    DateStart = Date.From(date_start),
    DateEnd = if
                date_end is null
              then
                Date.AddDays(Date.From(DateTime.LocalNow()), 1)
              else
                Date.From(date_end),
    CurrencyCode = currency,

    CurrencyID = [
        USD = "R01235",
        EUR = "R01239"
    ],
    DateFormat = "MM\/dd\/yyyy",
    HttpGetParams = Uri.BuildQueryString([
        Posted = "True",
        mode = "1",
        VAL_NM_RQ = try Record.Field(CurrencyID, CurrencyCode) otherwise CurrencyCode,
        FromDate = Date.ToText(DateStart, DateFormat),
        ToDate = Date.ToText(DateEnd, DateFormat)
    ]),
    Source = Excel.Workbook(
        Web.Contents(
            "http://www.cbr.ru/Queries/UniDbQuery/DownloadExcel/98956?" & HttpGetParams
        ),
        null,
        true),
    RC_Sheet = Source{[Item="RC",Kind="Sheet"]}[Data],
    PromotedHeaders = Table.PromoteHeaders(RC_Sheet, [PromoteAllScalars=true]),
    ChangedType = Table.TransformColumnTypes(
        PromotedHeaders,
        {
            {"nominal", Int64.Type},
            {"data", type date},
            {"curs", type number},
            {"cdx", type text}
        }
    )
in
    ChangedType

