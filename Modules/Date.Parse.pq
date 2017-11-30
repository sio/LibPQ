/**
Date.Parse:
    Improved date parser for strings containing dates in unspecified format.
**/
(datetext as text) =>
let
    /* List of enabled locales in order of preference */
    Locales = {
        null,  // system default
        "en",
        "en-US",
        "en-GB",
        "ru",
        "ru-RU",
        "ru-UA",
        "ru-BY",
        "de",
        "de-DE",
        "de-BE"
    },

    /* Common substitutions that turn a string into a readable date */
    Substitutions = {
        {"года", "г"},
        {"год", "г"}
    },

    /* Try all substitutions listed above and return the first successful result */
    TryAllSubstitutions = (datetext as text, reader as function) =>
        let
            Result = List.Last(
                List.Generate(
                    () => [i=-1, date=null],
                    each [i] < List.Count(Substitutions),
                    each [
                        i = [i] + 1,
                        date =
                            if
                                [date] is null
                            then
                                try reader(
                                        Text.Replace(
                                            datetext,
                                            Substitutions{i}{0},
                                            Substitutions{i}{1}
                                        )
                                    )
                                otherwise null
                            else
                                [date]
                    ],
                    each [date]
                )
            ),
            Return =
                if   Result is null
                then error "Could not read date with substitutions: " & datetext
                else Result
        in
            Return,

    /* Try all locales listed above and return the first successful result */
    TryAllLocales = (datetext as text) =>
        let
            Result = List.Last(
                List.Generate(
                    () => [i=-1, date=null],
                    each [i] < List.Count(Locales),
                    each [
                        i = [i] + 1,
                        date =
                            if
                                [date] is null
                            then
                                try Date.FromText(datetext, Locales{i})
                                otherwise null
                            else
                                [date]
                    ],
                    each [date]
                )
            ),
            Return =
                if   Result is null
                then error "Could not read date with locales: " & datetext
                else Result
        in
            Return,

    /* Execute all steps */
    CleanDateText = Text.Lower(Text.Trim(datetext)),
    Return = TryAllSubstitutions(CleanDateText, TryAllLocales)

in
    Return
