# LibPQ - a collection of reusable modules for Power Query M Language

This project offers a collection of functions and useful queries for Power
Query Formula Language (also known as M language) and a loader to import source
code from external modules into Power Query.

The loader supports importing from several sources and is compatible with
[@tycho01][tycho01]'s library, so you can use its
content in addition to the modules found in this repo. LibPQ supports importing
code from modules located on the filesystem or from the modules published on
the web.

[tycho01]: https://github.com/tycho01/pquery

# Installation and usage

### Copy source code to the filesystem (optional)

Download the [contents of this repo][zip] and extract it anywhere you want. If
you skip this step you will not be able to list all available modules with
`LibPQ()` call and every time you load a module LibPQ will access the network.

### Add LibPQ to the workbook

Create two blank queries in your workbook:

- **LibPQ** - copy the contents of [LibPQ.pq](LibPQ.pq) verbatim
- **LibPQPath** - provide location of modules source code (local and/or web).
  See sample at [LibPQPath-sample.pq](LibPQPath-sample.pq)

### Import LibPQ modules when writing your queries

Import any of the available modules via `LibPQ("modulename")` when writing your
queries in Advanced Editor.

To import all modules available locally use `LibPQ()` with no arguments (or
`null`). That will return a record where keys are module names and values are
the results of loading those modules (function object or output of a query).

[zip]: https://github.com/sio/LibPQ/archive/master.zip

# LibPQ modules
All modules are grouped into namespaces, much like the standard library:

- **Date** - Functions for working with dates
- **Factory** - Functions that create other functions
- **List** - Functions for working with lists
- **Module** - LibPQ tools for importing source code
- **Read** - Functions that import data
- **Table** - Functions for table operations
- **Tests** - Unit tests for LibPQ modules
- **Text** - Functions for working with text
- **UnitTest** - Unit testing framework


## Date functions

- **Date.IntervalFromText** -
  Given a string of text such as "Jan 2017 - Dec 2017" return a list of two
  dates corresponding to beginning and end of the interval

- **Date.Parse** -
  Improved date parser for strings containing dates in unspecified format

## Factory functions

- **Factory.Comparer** -
  Factory for creating comparison functions from conditions provided as text

## List functions

- **List.UseLastValid** -
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

- **Read.CSV** -
  Load arbitrary CSV file with unknown number of columns (up to 1000) and
  unknown number of extra lines before the column names (first column name has
  to be known)

- **Read.Parameter** -
  Fetch parameter value from a data table in current workbook

- **Read.Text** -
  Load text content from local file or from web

## Table functions

- **Table.ConcatenateRows** -
  Add all columns from tableB to tableA (with values)

- **Table.CountDuplicates** -
  Add a column to a table that will show the number of rows that contain the
  same value of key field as the current row.

- **Table.UseLastValid** -
  Validate all rows in the input table and replace the invalid ones with the
  previous valid value.

## Unit testing framework

- **UnitTest** is a basic unit testing framework built into LibPQ. [Read
  more...](UNITTESTING.md)

# Compatibility with @tycho01's library

LibPQ allows specifying multiple possible locations for source code, that's why
you can add [@tycho01's library][tycho01] as a fallback.

Any module from that library should be supported, though some will require
adding a `Load` query to your workbook. To create a `Load` alias for `LibPQ`
you need to:

- Create a new blank query
- Replace all its code with text `LibPQ`
- Save the query under the name `Load`

Now the `Load` function will be available from `#shared` context, and you
should be able to import any module from [@tycho01's library][tycho01].


# Contributing

All contributions are welcome!
Please check [CONTRIBUTING.md](CONTRIBUTING.md) for details


# License and copyright

Copyright © 2017 Vitaly Potyarkin
```
   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use these files except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
```
