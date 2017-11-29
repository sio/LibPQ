let
    /* Load data */
    Data = ОбъединенныеСправочники,

    /* Load rules */
    CheckPrefix = "TEST.",
    RulesSource = Excel.CurrentWorkbook(){[Name="Правила"]}[Content],
    Rules = Table.AddColumn(
                RulesSource,
                "Comparer",
                each fnMakeComparer(
                    [Поле1],
                    [Поле2],
                    [Сравнение],
                    [СложнаяПроверка])),
    RulesColumnNames = List.Transform(
                Rules[Название],
                each CheckPrefix & _),

    /* Run all checks */
    Loop = List.Generate(
                () => [i=-1, data=Data],
                each [i] < Table.RowCount(Rules),
                each [
                    i = [i] + 1,
                    data = Table.AddColumn(
                            [data],
                            RulesColumnNames{i},
                            each Rules[Comparer]{i}(_))
                    ]
                ),
    Result = List.Last(Loop)[data],
    ResultSum = Table.AddColumn(
                    Result,
                    CheckPrefix & "SUM",
                    each List.AllTrue(
                            Record.FieldValues(
                                Record.SelectFields(_, RulesColumnNames)
                            )
                        )
                    ),
    TypeLogicalPairs = List.Transform(
                            List.Select(
                                Table.ColumnNames(ResultSum),
                                each Text.StartsWith(_, CheckPrefix)
                            ),
                            each {_, type logical}
                        ),
    ResultWithTypes = Table.TransformColumnTypes(
                            ResultSum,
                            TypeLogicalPairs
                        ),
    ResultWithErrorMessage = Table.AddColumn(
        ResultWithTypes,
        CheckPrefix & "ShortMessage",
        each if Record.Field(_, CheckPrefix & "SUM")
             then ""
             else Text.AfterDelimiter(
                        Table.SelectRows(
                                Record.ToTable(_),
                                each Text.StartsWith([Name], CheckPrefix)
                                     and [Value] = false
                            )[Name]{0},
                        CheckPrefix)
        ),
    ResultWithLongMessage = Table.NestedJoin(
        ResultWithErrorMessage,
        CheckPrefix & "ShortMessage",
        Rules,
        "Название",
        "MSG",
        JoinKind.LeftOuter),
    ResultOutput = Table.ExpandTableColumn(
        ResultWithLongMessage,
        "MSG",
        {"Сообщение"},
        {"Сообщение об ошибке"})
in
    ResultOutput
