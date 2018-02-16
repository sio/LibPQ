/**
Return the path to the newest file in directory that meets the specified
requirements. Return null if no file or subdirectory meets the requirements.

By default return the newest subdirectory.

Requirements are specified as function that accepts a single argument - row
record from Folder.Contents output. If that function returns true, the file in
question is considered fit to the requirements. See implementation of
DefaultFilter for an example.

By default Folder.Contents output is sorted by modification date. You can use
optional third argument to provide a different sort order:
    - Text argument is treated as field name;
    - List of lists is treated as list of field names paired with Order.*
      enumerations;
    - A single {field_name, order_enum} pair without enclosing list is also
      acceptable.
**/

// TODO:
// - unit tests (how?)

(directory as text, optional requirements as function, optional sort_field) =>
let
    DefaultFilter = each [Attributes][Kind] = "Folder",
    Filter = if requirements is null then DefaultFilter else requirements,

    SortOrder =
        if
            sort_field is null
        then
            {{"Date modified", Order.Descending}}
        else if
            sort_field is text
        then
            {{sort_field, Order.Descending}}
        else if
            sort_field is list and sort_field{0} is list
        then
            sort_field
        else if
            sort_field is list
        then
            {sort_field}
        else
            error "unsupported argument type for sort_field",

    Candidates = Table.SelectRows(
        Folder.Contents(directory),
        Filter
    ),
    Sorted = Table.Sort(Candidates, SortOrder),
    Chosen = List.First(
        Table.ToRecords(Sorted)
    ),

    Return =
        if
            Chosen is null
        then
            null
        else
            Chosen[#"Folder Path"] & Chosen[Name]
in
    Return
