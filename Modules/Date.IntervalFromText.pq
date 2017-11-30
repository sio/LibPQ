/**
Date.IntervalFromText:
    Given a string of text such as "Jan 2017 - Dec 2017" return a list of two
    dates corresponding to beginning and end of the interval.
**/

(date_interval as text,
optional delimiter as text,
optional full_months as logical) =>
let
    Date.Parse = Date.FromText, // TODO: need a better date parser function

    /* Default parameter values */
    Delimiter = if delimiter is null then " - " else delimiter,
    FullMonth = if
                    full_months is null
                then
                    if
                        EndStrings{1} is null
                    then
                        Date.Day(DateStart) = 1
                    else
                        Date.Day(DateEndParsed) = 1 and Date.Day(DateStart) = 1
                else
                    full_months,

    EndStrings = List.Combine({
        Text.Split(date_interval, Delimiter),
        {null}
    }),
    DateStart = Date.Parse(EndStrings{0}),
    DateEndParsed = try Date.Parse(EndStrings{1}) otherwise null,
    DateEndGuess =
        if
            EndStrings{1} is null
        then
            DateStart
        else
            DateEndParsed,
    DateEnd = if FullMonth then Date.EndOfMonth(DateEndGuess) else DateEndGuess
in
    {DateStart, DateEnd}
