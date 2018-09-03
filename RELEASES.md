# LibPQ release history

LibPQ is a library for importing Power Query M language source files from local
and/or web storage. The project follows [semantic versioning](https://semver.org/)
specification.

This document describes the changes between releases of LibPQ. [Keeping a
changelog](http://keepachangelog.com) is important!

Plans and ideas for future versions can be found in the [roadmap](ROADMAP.md).

## Unreleased changes (currently in git master)

**New features**

- Support for [fact based unit tests](Docs/UnitTesting_with_Facts.md)
- Support unlimited number of test runners for different test suite types with
  [UnitTest.Discover](Modules/UnitTest.Discover.pq). Runner is determined
  based on the value of `LibPQ.TestSuite` meta field. Test runners have to be
  API compatible with the reference implementation
  ([UnitTest.Run](Modules/UnitTest.Run.pq))


## Version 1.1.0 (2018-07-11)

#### Git commit: 4aa1b5e522f72e90083f9335444e610326e3b737

This release adds a few minor features.

The library has been around for half a year already. The author has been using
it regularly to create new reports and refresh existing ones, no significant
issues had arisen. The project is considered suitable for daily use.

**New features**

- New assertion function `NotEqual` in
  [UnitTest.Assert](Modules/UnitTest.Assert.pq)
- [VBA helper module](VBA/LibPQ_ThisWorkbook.bas) that simplifies access to the
  metadata about the current workbook

**New modules**

- [Function.Chain](Modules/Function.Chain.pq) -
  Apply a sequence of operations to the input value



## Version 1.0.0 (2018-02-21)

#### Git commit: ae988cddc0b0996019cc2ccf8a486a40524337d6

This is the first release of LibPQ. The library and the loader are considered
feature full and stable.

Most of the features are described in the [README](README.md) and in
[documentation][docs]. Introductory overview is available at [author's
blog][intro].


#### New features
- Import source code from plain text files located on disk or on the web
- Unlimited number of import locations ordered by priority
- [Unit testing][unittesting] framework
- Show [docstrings] in Power Query user interface
- A collection of general purpose [functions and queries][modules]
- Compatibility with [@tycho01's library][tycho01]

[docs]: Docs/README.md
[docstrings]: Docs/Docstrings.md
[intro]: https://potyarkin.ml/posts/2018/expanding-power-query-standard-library-introducing-libpq/
[modules]: Docs/Modules.md
[tycho01]: https://github.com/tycho01/pquery
[unittesting]: Docs/UnitTesting.md
