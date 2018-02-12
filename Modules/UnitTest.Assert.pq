/**
A collection of assertion functions for LibPQ UnitTest framework

Calling an assertion function results in one of three outcomes:
- If assertion is not true, the function has to raise an error with reason
  "LibPQ.AssertionError" (test FAILED)
- If an error occurs while calculating the assertion value, the function passes
  that error up unchanged (test ERROR)
- If assertion is true, the function returns any value without raising an
  error. The returned value is not relevant (test PASSED)
**/

[
    /** Default error reason **/
    Error.Reason = LibPQ("UnitTest.Constants")[Error.Reason],

    /** Basic assertion function. Check if expression is true **/
    True = (expression, optional message as nullable text, optional detail) =>
        () =>
        let
            Message = if message = null then "value is not true" else message,
            Detail = if detail = null then expression else detail,
            Return =
                if expression = true
                then expression
                else error Error.Record(Error.Reason, Message, Detail)
        in
            Return,

    /** Check if expression is false **/
    False = (expression, optional message as nullable text, optional detail) =>
        let
            Message = if message = null then "value is not false" else message,
            Detail = if detail = null then expression else detail,
            Return = True(expression = false, Message, Detail)
        in
            Return,

    /** Check if a and b are equal **/
    Equal = (a, b, optional message as nullable text, optional detail) =>
        let
            Message = if message = null then "values are not equal" else message,
            Detail = if detail = null then {a,b} else detail,
            Return = True(a = b, Message, Detail)
        in
            Return,

    /** Check if zero-argument function raises error **/
    Raises = (func, reason as text, optional message as nullable text, optional detail) =>
        let
            Message = if message = null then "does not raise " & reason else message,
            Detail = if detail = null then func else detail,
            Reason = try (try func())[Error][Reason] otherwise null,
            Return = True(Reason = reason, Message, Detail)
        in
            Return
]
