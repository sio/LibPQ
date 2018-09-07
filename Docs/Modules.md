# LibPQ modules
All modules are grouped into namespaces, much like the standard library:

- **Date** - Functions for working with dates
- **Factory** - Functions that create other functions
- **Folder** - Functions for manupulating folders and their contents
- **Function** - Functions that operate on other functions
- **List** - Functions for working with lists
- **Module** - LibPQ tools for importing source code
- **Read** - Functions that import data
- **Table** - Functions for table operations
- **Tests** - Unit tests for LibPQ modules
- **Text** - Functions for working with text
- **[UnitTest][unittesting]** - Unit testing framework

## Date functions

- **[Date.IntervalFromText]** -
  Given a string of text such as "Jan 2017 - Dec 2017" return a list of two
  dates corresponding to beginning and end of the interval

- **[Date.Parse]** -
  Improved date parser for strings containing dates in unspecified format

## Factory functions

- **[Factory.Comparer]** -
  Factory for creating comparison functions from conditions provided as text

## Folder functions

- **[Folder.Latest]** -
  Get the path of the newest subdirectory or file in the given folder. Supports
  custom sort order and filter functions.

## Function functions

- **[Function.Chain]** -
  Apply a sequence of operations to the input value. Input for each consecutive
  operation is the output from the previous one.

## List functions

- **[List.UseLastValid]** -
  Validate all items in the input list and replace the invalid ones with the
  previous valid value.


## Module functions

- **Module.BuildPath** -
  Calculate where the function code is located

- **Module.Explore** -
  Find all modules in the list of directories

- **Module.FromPath** -
  Load Power Query function or module from file

- **Module.Import** -
  Import a module from default locations (LibPQPath)

- **Module.ImportAny** -
  Import module (first match) from the list of possible locations

- **Module.Library** -
  A record with all available local modules already imported

- **Module.NameFromProper** -
  Convert proper module name (with dots) into something that follows Power
  Query naming restrictions for queries in workbook

- **Module.NameToProper** -
  Convert module name to proper filename

## Read functions

- **[Read.CSV]** -
  Load arbitrary CSV file with unknown number of columns (up to 1000) and
  unknown number of extra lines before the column names (first column name has
  to be known)

- **[Read.Parameter]** -
  Fetch parameter value from a data table in current workbook

- **Read.Text** -
  Load text content from local file or from web

## Table functions

- **[Table.ConcatenateRows]** -
  Add all columns from tableB to tableA (with values)

- **[Table.CountDuplicates]** -
  Add a column to a table that will show the number of rows that contain the
  same value of key field as the current row.

- **[Table.NumberColumns]** -
  Transform selected columns' type to number, replace null values with zeros.

- **[Table.PromoteHeadersNonEmpty]** -
  Promote the first table row as column names, but keep the current header
  if the value in the first row is empty.

- **[Table.UseLastValid]** -
  Validate all rows in the input table and replace the invalid ones with the
  previous valid value.

## Unit testing framework

- **UnitTest** is a basic unit testing framework built into LibPQ. [Read
  more...][unittesting]

[unittesting]: UnitTesting.md

[Date.IntervalFromText]: ../Modules/Date.IntervalFromText.pq
[Date.Parse]: ../Modules/Date.Parse.pq
[Factory.Comparer]: ../Modules/Factory.Comparer.pq
[Folder.Latest]: ../Modules/Folder.Latest.pq
[Function.Chain]: ../Modules/Function.Chain.pq
[List.UseLastValid]: ../Modules/List.UseLastValid.pq
[Read.CSV]: ../Modules/Read.CSV.pq
[Read.Parameter]: ../Modules/Read.Parameter.pq
[Table.ConcatenateRows]: ../Modules/Table.ConcatenateRows.pq
[Table.CountDuplicates]: ../Modules/Table.CountDuplicates.pq
[Table.NumberColumns]: ../Modules/Table.NumberColumns.pq
[Table.PromoteHeadersNonEmpty]: ../Modules/Table.PromoteHeadersNonEmpty.pq
[Table.UseLastValid]: ../Modules/Table.UseLastValid.pq
[Tests.ConcatenateRows]: ../Tests/Tests.ConcatenateRows.pq
[Tests.UseLastValid]: ../Tests/Tests.UseLastValid.pq
[UnitTest.Assert]: ../Modules/UnitTest.Assert.pq
[UnitTest.Constants]: ../Modules/UnitTest.Constants.pq
[UnitTest.Discover]: ../Modules/UnitTest.Discover.pq
[UnitTest.Run]: ../Modules/UnitTest.Run.pq
