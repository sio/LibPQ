- [x] Look into LibPQ("CrossUsage") error when loading from tycho01 GitHub
    - [ ] Create issue or submit a pull request: incorrect module name "Table.Crossjoin"
          instead of "Table.CrossJoin" in line 2 of `CrossUsage.pq` as tycho01's repo
- [ ] Unit testing
    - [ ] Store test functions in meta field "LibPQ.Tests" as a function
          or a list of functions
    - [ ] Test function takes no arguments. Its return value can be anything,
          it is not to be used anywhere.
        - If test passes, the function should return a value
        - If test fails, the functions must raise error with a message, for
          example `error "Division by zero"`
    - [ ] Module.Test("modulename") - run test functions for modulename, if any.
          Return a list of records that contain results for each test:
        - success = true for passed, false for failed or error
        - message = error message (as in `(try testfunc())[Error][Message]`) for failed
          tests, null for successful tests

          If a module has no tests return `{[success=null, message="No tests for $modulename"]}`.
    - [ ] Module.TestLibrary() - run Module.Test for each module in Module.Library.
          Combine all results into a list and transform it to table. Show modules that
          contain no tests.
