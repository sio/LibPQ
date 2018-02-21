/**
Unit tests for importing metadata
**/

[
    // Wrap List.Zip in a LibPQ module to see which metadata gets passed on
    WrappedBuiltin = LibPQ("Tests.Docstrings.Data"),

    Metadata = Value.Metadata(WrappedBuiltin),
    Typedata = Value.Metadata(Value.Type(WrappedBuiltin)),

    testHasTypeData = Assert[True](
        // Built-in List.Zip has Documentation.Category, but LibPQ does not
        // offer such field. Pre-existing data must not be lost
        Record.HasFields(Typedata, "Documentation.Category"),
        "List.Zip lost Documentation.Category metadata upon import"
    ),

    testHasLibPQData = Assert[True](
        Record.HasFields(Metadata, "LibPQ.Module")
    ),
    testHasLibPQTypeData = Assert[True](
        Record.HasFields(Typedata, "LibPQ.Module")
    ),

    /** Import assertion functions **/
    Assert = LibPQ("UnitTest.Assert")
] meta [LibPQ.TestSuite = 1]
