/**
Helper function that generates a list of tests functions to be used as subtests

constructor:
    A function that takes any number of arguments and returns a valid test
    function

arguments:
    A list of lists. Any number of sets of arguments for generating individual
    test cases
**/
(constructor as function, arguments as list) as list =>
    List.Transform(
        arguments,
        each Function.Invoke(constructor, _)
    )
