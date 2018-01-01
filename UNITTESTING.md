# Unit testing with LibPQ

LibPQ offers a basic unit testing framework, which consists of the following
modules:

- **[UnitTest.Run][Run]** - runner for individual test suites
- **[UnitTest.Assert][Assert]** - a collection of assertion functions
- **[UnitTest.Constants][Constants]** - framework-wide constants

# Writing tests

## Test function

A test function is a function that takes zero arguments and produces one of
three outcomes when called:

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

`TODO: define metadata for test suite`

## Assertion functions

In order to simplify writing the tests LibPQ offers some useful assertion
functions in [UnitTest.Assert][Assert] module. Each of the functions in that
module is a valid test function that tests some simple assertion. You can use
them as building blocks for writing your own tests.

[Assert]: Modules/UnitTest.Assert.pq
[Constants]: Modules/UnitTest.Constants.pq
[Run]: Modules/UnitTest.Run.pq
