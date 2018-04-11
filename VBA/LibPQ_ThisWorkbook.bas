Attribute VB_Name = "LibPQ_ThisWorkbook"
Option Explicit
'
' This module allows you to access metadata about current workbook from Power
' Query.
'
' To create the record with neccessary data, run `LibPQ_UpdateThisWorkbook`
'
' To update workbook information automatically call that macro from
' `Workbook_Open` event
'


Public Sub LibPQ_UpdateThisWorkbook()
' Update ThisWorkbook query with information about current workbook
    Const Query As String = "ThisWorkbook"
    Call ReplaceQuery(Query, ThisWorkbookData())
End Sub


Private Function ThisWorkbookData() As String
' Gather information about current workbook and present it as M record
    Dim Fields As New Collection
    Dim Values As New Collection
    Dim WB As Excel.Workbook

    Set WB = ThisWorkbook

    Fields.Add "Directory"
    Values.Add WB.Path

    Fields.Add "FullPath"
    Values.Add WB.FullName

    Fields.Add "Filename"
    Values.Add WB.Name

    ThisWorkbookData = MakeRecord(Fields, Values)
End Function


Private Function ReplaceQuery(Name As String, Code As String)
' Replace the code of the PQ Query
    Dim CurrentWorkbook As Excel.Workbook
    Dim Query As Excel.WorkbookQuery

    Set CurrentWorkbook = ThisWorkbook
    Set Query = Nothing

    On Error Resume Next
    Set Query = CurrentWorkbook.Queries(Name)
    On Error GoTo 0

    If Query Is Nothing Then
        Set Query = CurrentWorkbook.Queries.Add(Name, Code)
    Else
        Query.Formula = Code
    End If

    Set ReplaceQuery = Query
End Function


Private Function MakeRecord(Keys, Values) As String
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
