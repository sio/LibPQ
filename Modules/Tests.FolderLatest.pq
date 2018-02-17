/**
Unit tests for Folder.Latest
**/

[
    Folder.Latest = LibPQ("Folder.Latest"),

    /* All we know about target computer is that it has LibPQ and this module */
    // this part will fail if module source code is loaded from web location
    ValidFilePath = Value.Metadata(Folder.Latest)[LibPQ.Source],
    ValidDirPath = Text.BeforeDelimiter(
        ValidFilePath,
        "\", // for now Power Query is Windows only
        {0, RelativePosition.FromEnd}
    ),

    /* This test is not very conclusive, need an idea for another one */
    testExistingFile = Assert[True](
        Text.Length(
            Folder.Latest(
                ValidDirPath,
                each [Extension] = ".pq"
            )
        ) > 1
    ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
