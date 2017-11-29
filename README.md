# LibPQ - a collection of reusable modules for Power Query M Language

This project offers a collection of functions and useful queries for Power
Query Formula Language (also known as M language) and a loader to import source
code from external modules into Power Query.

The loader supports importing from several sources and is compatible with
[@tycho01](https://github.com/tycho01/pquery)'s library, so you can use its
content in addition to the modules found in this repo. LibPQ supports importing
code from modules located on the filesystem or from the modules published on
the web.


# Installation and usage

Create two blank queries in your workbook:

- **LibPQ** - copy the contents of [LibPQ.pq](LibPQ.pq) verbatim
- **LibPQPath** - provide location of modules source code (local and/or web).
  See sample at [LibPQPath-sample.pq](LibPQPath-sample.pq)

Import any of the available modules via `LibPQ("modulename")` when writing your
queries in Advanced Editor.


# LibPQ modules
All modules are grouped into namespaces, much like the standard library:

- **Date** - Functions for working with dates
- **Factory** - Functions that create other functions
- **List** - Functions for working with lists
- **Module** - LibPQ tools for importing source code
- **Read** - Functions that import data
- **Text** - Functions for working with text


## Factory

- **Factory.Comparer** -
  Factory for creating comparison functions from conditions provided as text


## Module

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

## Read

- **Read.CSV** -
  Load arbitrary CSV file with unknown number of columns (up to 1000) and
  unknown number of extra lines before the column names (first column name has
  to be known)

- **Read.Parameter** -
  Fetch parameter value from a data table in current workbook

- **Read.Text** -
  Load text content from local file or from web


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
