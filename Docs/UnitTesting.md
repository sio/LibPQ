# Unit testing with LibPQ

LibPQ offers a basic unit testing framework, which consists of the following
modules:

- **[UnitTest.Assert][Assert]** - a collection of assertion functions
- **[UnitTest.Constants][Constants]** - framework-wide constants
- **[UnitTest.Discover][Discover]** - discover and run unit tests from all
  local sources
- **[UnitTest.Run][Run]** - runner for individual test suites
- **[UnitTest.Subtests][Subtests]** - helper function for writing subtests

# Writing tests

## Test function (test case)

Individual test cases are implemented using test functions. A test function is
a function that takes zero arguments and produces one of three outcomes when
called:

1. If test is succesfull (*PASSED*) the test function returns any value. The
   value itself is irrelevant.
2. If test is unsuccesfull (*FAILED*) the test function raises
   `LibPQ.AssertionError`.  (This error reason is defined in
   [UnitTest.Constants][Constants])
3. If the test code itself raises an error the test is considered neither
   succesfull nor failed, and the error must not be silenced (*ERROR*)

## Test suite

A test suite is a collection of test functions, usually related to each other
in some way. Test suite has to store test functions as a record with field
names starting with "test" (the test prefix is defined in
[UnitTest.Constants][Constants]).

Any field of the test suite which name does not start with "test" prefix is
ignored by the UnitTest framework.

It is recommended to add a metadata field to the test suite record to enable
automated tests discovery. The field and its value are `LibPQ.TestSuite = 1`.
The number `1` indicates the version of test suite format and will be
incremented in future if any non-backwards compatible changes will be
introduced.

Suites without the metadata will still be executable by test runners but will
not be visible to discovery tools.

## Assertion functions

In order to simplify writing the tests LibPQ offers some useful assertion
functions in [UnitTest.Assert][Assert] module.

Each of the functions in that module is a valid test function that tests some
simple assertion. You can use them as building blocks for writing your own
tests.

## Subtests

When you need to run the same tests against slightly different parameters
writing all the variations one by one can become tedious.

LibPQ will treat a list of test functions that are stored in the same test
suite field as a group of subtests. It will execute them until an error occurs,
and that error will be treated as the test result.

There is also a [helper function][Subtests] that simplifies creating subtests.

## Test fixtures

At this moment there are no special tools for defining and invoking test
fixtures, but `setUp` and `tearDown` field names in test suite record should be
considered reserved for that purpose.

To create test fixture now you can add a helper function to the test suite and
store it in any field which name does not start with "test" prefix. Such
function(s) will have to be invoked explicitly from each individual test.

## Sample code

Check the code of [sample][Sample] test suite and the test suite
[snippet][Snippet] to see LibPQ unit tests in action.

# Running tests and test discovery

Use [UnitTest.Run][Run] function to run individual test suites (passed by
module name or as the test suite record).

Use [UnitTest.Discover][Discover] function to automatically discover and run
all test suites from local sources.

# Fact based unit tests

If you are familiar with [fact based unit tests][Microsoft Unit Testing] (as
shown in Microsoft documentation) you can continue to use that approach with
LibPQ UnitTest framework. Integrating existing fact based test suites will
require some extra code, but the tests themselves need no modification. See
[this article][Fact based tests] for more information.

[Assert]: ../Modules/UnitTest.Assert.pq
[Constants]: ../Modules/UnitTest.Constants.pq
[Discover]: ../Modules/UnitTest.Discover.pq
[Run]: ../Modules/UnitTest.Run.pq
[Sample]: ../Samples/Tests.Sample.pq
[Subtests]: ../Modules/UnitTest.Subtests.pq
[Snippet]: ../Samples/Tests.Snippet.pq
[Microsoft Unit Testing]: https://docs.microsoft.com/en-us/power-query/handlingunittesting
[Fact based tests]: UnitTesting_with_Facts.md
