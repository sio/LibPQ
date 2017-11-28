Private Sub Workbook_Open()
    ' WARNING!
    '   Potential security risk!
    '   To be applied with care!
    ThisWorkbook.Queries.FastCombine = True
    ThisWorkbook.Saved = True
End Sub
