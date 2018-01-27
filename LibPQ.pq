/**
LibPQ:
    Access Power Query functions and queries stored in source code modules
    on filesystem or on the Web.

Project website:
    https://github.com/sio/LibPQ
**/

let
    /* Read LibPQ settings */
    Sources.Local = LibPQPath[Local],
    Sources.Web   = LibPQPath[Web],

    /* Constants */
    EXTENSION = ".pq",
    PATHSEPLOCAL = Text.Start("\\",1),
    PATHSEPREMOTE = "/",
    VERSIONDATE = #date(2017,11,29),  // Date of last significant library change
    ERR_SOURCE_UNREADABLE = "LibPQ.ReadError",

    /* Load text content from local file or from web */
    Read.Text = (destination as text, optional local as logical) =>
        let
            Local = if local is null then true else local,
            Fetcher = if Local then File.Contents else Web.Contents
        in
            Text.FromBinary(
                Binary.Buffer(
                    try
                        Fetcher(destination)
                    otherwise
                        error Error.Record(
                            ERR_SOURCE_UNREADABLE,
                            "Read.Text: can not fetch from destination",
                            destination
                        )
                )
            ),

    /* Load Power Query function or module from file */
    Module.FromPath = (path as text, optional local as logical) =>
        Expression.Evaluate(Read.Text(path, local), #shared),

    /* Calculate where the function code is located */
    Module.BuildPath = (funcname as text, directory as text, optional local as logical) =>
        let
            /* Defaults */
            Local = if local is null then true else local,
            PathSep = if Local then PATHSEPLOCAL else PATHSEPREMOTE,

            /* Path building */
            ProperDir = if Text.EndsWith(directory, PathSep)
                        then directory
                        else directory & PathSep,
            ProperName = Module.NameToProper(funcname),
            Return = ProperDir & ProperName & EXTENSION
        in
            Return,

    /* Module name converters */
    Module.NameToProper = (name) => Text.Replace(name, "_", "."),
    Module.NameFromProper = (name) => Text.Replace(name, ".", "_"),

    /* Find all modules in the list of directories */
    Module.Explore = (directories as list) =>
        let
            Files = List.Generate(
                () => [i = -1, results = 0],
                each [i] < List.Count(directories),
                each [
                    i = [i]+1,
                    folder = directories{i},
                    iserror = (try Table.RowCount(
                                    Folder.Contents(folder)
                               ))[HasError],  // For some weird reason try does
                                              // not catch DataSource error.
                                              // Check "try Folder.Contents("C:\none")"
                                              // it will return [HasError]=false
                    files = if iserror then
                                #table({"Name","Extension"},{})
                            else
                                Folder.Contents(folder),
                    filter = Table.SelectRows(
                                files,
                                each [Extension] = EXTENSION
                            ),
                    results = Table.RowCount(filter),
                    module = List.Transform(
                                    filter[Name],
                                    each Text.BeforeDelimiter(
                                        _,
                                        EXTENSION,
                                        {0,RelativePosition.FromEnd}
                                    )
                                )
                ],
                each [
                    folder = [folder],
                    module = [module],
                    results = [results]
                ]
            ),
            Return = try
                        Table.ExpandListColumn(
                            Table.FromRecords(
                                List.Select(Files, each [results]>0)
                            ),
                            "module"
                        )
                     otherwise
                        #table({"folder", "module", "results"},{})
        in
            Return,

    /* Import module (first match) from the list of possible locations */
    Module.ImportAny = (name as text, locations as list, optional local as logical) =>
        let
            Paths = List.Transform(
                        locations,
                        each Module.BuildPath(name, _, local)
                    ),
            Loop = List.Generate(
                () => [i=-1, object=null],
                each [i] < List.Count(Paths),
                each [
                    i = [i] + 1,
                    object = if [object] is null
                             then try Module.FromPath(Paths{i}, local)
                                  otherwise null
                             else [object]
                ],
                each [object]
            ),
            Return = try
                        List.Select(Loop, each _ <> null){0}
                     otherwise
                        error "Module.ImportAny: `" & name & "` not found"
        in
            Return,

    /* Import a module from default locations (LibPQPath) */
    Module.Import = (name as text) =>
             try
                Record.Field(#shared, Module.NameFromProper(name))
             otherwise try
                Record.Field(#shared, Module.NameToProper(name))
             otherwise try
                Record.Field(Helpers, name)
             otherwise try
                Module.ImportAny(name, Sources.Local)
             otherwise try
                Module.ImportAny(name, Sources.Web, false)
             otherwise
                error "Module.Import: `" & name & "` not found or has syntax errors",

    /* Last touch: export helper functions defined above */
    Helpers = [
        Read.Text = Read.Text,
        Module.FromPath = Module.FromPath,
        Module.BuildPath = Module.BuildPath,
        Module.NameToProper = Module.NameToProper,
        Module.NameFromProper = Module.NameFromProper,
        Module.Explore = Module.Explore,
        Module.ImportAny = Module.ImportAny
    ],
    Library.Names = List.Distinct(Module.Explore(Sources.Local)[module]),
    Library = List.Last(
        List.Generate(
            () => [i=-1,record=[]],
            each [i] < List.Count(Library.Names),
            each [
                i = [i] + 1,
                record = Record.AddField(
                    [record],
                    Library.Names{i},
                    let
                        Try = try Module.Import(Library.Names{i}),
                        Return = if Try[HasError] then Try[Error] else Try[Value]
                    in
                        Return
                )
            ],
            each [record]
        )
    ),
    Module.Library = Record.Combine({Helpers, Library}),

    /* Main function */
    Main = (optional modulename as nullable text) =>
        if modulename is null
        or modulename = "Module.Library"
        then
            Module.Library
        else if modulename = "Module.Import"
        then
            Module.Import
        else
            Module.Import(modulename)
in
    Main
