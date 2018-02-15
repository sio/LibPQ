/**
Return the path to the newest file in directory that meets the specified
requirements. Return null if no file or subdirectory meets the requirements.

By default return the newest subdirectory.

Requirements are specified as function that accepts a single argument - row
record from Folder.Contents output. If that function returns true, the file in
question is considered fit to the requirements. See implementation of
DefaultFilter for an example.
**/

// TODO:
// - unit tests (how?)
// - add to module list

(directory as text, optional requirements as function) =>
let
    DefaultFilter = each [Attributes][Kind] = "Folder",
    Filter = if requirements is null then DefaultFilter else requirements,

    Candidates = Table.SelectRows(
        Folder.Contents(directory),
        Filter
    ),
    Sorted = Table.Sort(
        Candidates,
        {{"Date modified", Order.Descending}}
    ),
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
