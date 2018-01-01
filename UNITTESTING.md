# Unit testing with LibPQ

LibPQ offers a basic unit testing framework, which consists of the following
modules:

- **UnitTest.Run** - runner for individual test suites
- **UnitTest.Assert** - a collection of assertion functions
- **UnitTest.Config** - framework-wide constants

# Writing tests

## Test function

A test function is a function that takes zero arguments and produces one of
three outcomes when called:

1. If test is succesfull (*PASSED*) the test function returns any value.
2. If test in unsuccesfull (*FAILED*) the test function raises
   LibPQ.AssertionError.  (This error reason is defined in UnitTest.Constants.pq)
3. If the test code itself raises an error the test is considered neither
   succesfull nor failed, and the error must not be silenced (*ERROR*)

## Test suite

A test suite is a collection of test functions, usually related to each other
in some way. Test suite has to store test functions as a record with values
starting with "test" (the test prefix is defined in UnitTest.Constants).

Any field of test suite which name does not start with "test" prefix is ignored
by the UnitTest framework.

TODO: define metadata for test suite
