# LibPQ - a collection of reusable modules for Power Query M Language

This project offers a collection of functions and useful queries for Power
Query Formula Language (also known as M language) and a loader to import source
code from external modules into Power Query.

The loader supports importing from several sources and is compatible with
[https://github.com/tycho01/pquery](@tycho01)'s library, so you can use its
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

**TODO**: List of available modules and their descriptions will be added here.


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
