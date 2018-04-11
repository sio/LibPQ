Attribute VB_Name = "LibPQ_ThisWorkbook"
Option Explicit

Public Function ReplaceQuery(name As String, code As String)
    Dim CurrentWorkbook As Excel.Workbook
    Dim Query As Excel.WorkbookQuery

    Set CurrentWorkbook = ThisWorkbook
    Set Query = Nothing

    On Error Resume Next
    Set Query = CurrentWorkbook.Queries(name)
    On Error GoTo 0

    If Query Is Nothing Then
        Set Query = CurrentWorkbook.Queries.Add(name, code)
    Else
        Query.Formula = code
    End If

    Set ReplaceQuery = Query
End Function
