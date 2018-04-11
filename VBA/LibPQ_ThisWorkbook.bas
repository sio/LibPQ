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


Public Function MakeRecord(Keys, Values) As String
' Translate collections (or arrays) of keys and values into Power Query M Language record
    Dim i
    Dim IndexStart As Long
    Dim IndexEnd As Long

    IndexStart = -1
    IndexEnd = -1
    On Error Resume Next
        ' try array
        IndexStart = LBound(Keys)
        IndexEnd = UBound(Keys)
    On Error GoTo 0
    If IndexStart = -1 Or IndexEnd = -1 Then
        ' if not array then it's a collection
        IndexStart = 1
        IndexEnd = Keys.Count
    End If

    MakeRecord = "["
    For i = IndexStart To IndexEnd
        MakeRecord = MakeRecord & vbCrLf & "    " & CStr(Keys(i)) & " = " & """" & CStr(Values(i)) & """"
        If i <> IndexEnd Then MakeRecord = MakeRecord & ","
    Next
    MakeRecord = MakeRecord & vbCrLf & "]"
End Function
