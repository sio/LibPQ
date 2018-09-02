/**
Helper function that packs arguments into a record.

This is a part of compatibility layer between LibPQ and Microsoft's framework
for unit testing in Power Query

More information: https://docs.microsoft.com/en-us/power-query/handlingunittesting
**/

(test_name as text, expected_value, actual_value) =>
[
    name = test_name,
    expected = expected_value,
    actual = actual_value
]
