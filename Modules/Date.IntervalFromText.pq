/**
Date.IntervalFromText:
    Given a string of text such as "Jan 2017 - Dec 2017" return a list of two
    dates corresponding to beginning and end of the interval.
**/

(date_interval as text,
optional delimiter as text,
optional full_months as logical) =>
let
    Date.Parse = try LibPQ("Date.Parse") otherwise Date.FromText,

    /* Predefined intervals */
    Presets = #table(
        {"interval", "start", "end"},
        {
            {"1 квартал", "январь", "март"},
            {"2 квартал", "апрель", "июнь"},
            {"3 квартал", "июль", "сентябрь"},
            {"4 квартал", "октябрь", "декабрь"},
            {"1 полугодие", "январь", "июнь"},
            {"2 полугодие", "июль", "декабрь"},
            {"9 месяцев", "январь", "сентябрь"}
        }
    ),
    PresetFullYear = [
        trim = {",","."," ",";"},
        remove = {"г", "год"}
    ],

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

    /* Check if date_interval represents full year */
    YearCandidates =
        List.Transform(
            PresetFullYear[remove],
            each
                try
                    Number.FromText(
                        Text.Trim(
                            Text.Replace(Text.Lower(date_interval), _, ""),
                            PresetFullYear[trim]
                        )
                    )
                otherwise
                    null
        ),
    YearDetected = List.Select(YearCandidates, each _ <> null){0},
    YearText =
        try
            Text.From(#date(YearDetected, 1, 1)) &
            Delimiter &
            Text.From(#date(YearDetected, 12, 31))
        otherwise
            null,

    /* Apply substitution presets if necessary */
    SelectedPreset =
        try
            Table.ToRecords(
                Table.SelectRows(
                    Table.AddColumn(
                        Presets,
                        "match",
                        each Text.Contains(
                            Text.Lower(date_interval),
                            [interval]
                        )
                    ),
                    each [match] = true
                )
            ){0}
        otherwise
            null,
    ApplyPreset = (interval as text, preset as record) =>
        let
            input = Text.Lower(interval),
            start = Text.Replace(input, preset[interval], preset[start]),
            end = Text.Replace(input, preset[interval], preset[end])
        in
            start & Delimiter & end,
    InputWithPresetsApplied =
        if
            SelectedPreset is null
        then
            date_interval
        else
            ApplyPreset(date_interval, SelectedPreset),

    /* Parsing */
    EndStrings = List.Combine({
        Text.Split(
            if
                YearText is null
            then
                InputWithPresetsApplied
            else
                YearText,
            Delimiter),
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
