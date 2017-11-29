/**
LibPQ:
    Access Power Query functions and queries stored in source code modules
    on filesystem or on the Web.
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

    /* Load text content from local file or from web */
    Text.Load = (destination as text, optional local as logical) =>
        let
            Local = if local is null then true else local,
            Fetcher = if Local then File.Contents else Web.Contents
        in
            Text.FromBinary(
                Binary.Buffer(
                    Fetcher(destination)
                )
            ),

    /* Load Power Query function or module from file */
    Module.FromPath = (path as text, optional local as logical) =>
        Expression.Evaluate(Text.Load(path, local), #shared),

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
                    files = Folder.Contents(folder),
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
            Return = Table.ExpandListColumn(
                            Table.FromRecords(
                                List.Select(Files, each [results]>0)
                            ),
                            "module"
                        )
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

    /* Import a module from default locations (LibPQ.Sources) */
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
                error "Module.Import: `" & name & "` not found",

    /* Last touch: export helper functions defined above */
    Helpers = [
        Text.Load = Text.Load,
        Module.FromPath = Module.FromPath,
        Module.BuildPath = Module.BuildPath,
        Module.NameToProper = Module.NameToProper,
        Module.NameFromProper = Module.NameFromProper,
        Module.Explore = Module.Explore,
        Module.ImportAny = Module.ImportAny,
        Module.Import = Module.Import,
        Module.Library = Module.Library
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
                    Module.Import(Library.Names{i})
                )
            ],
            each [record]
        )
    ),
    Module.Library = Record.Combine({Helpers, Library}) // TODO: Library
in
    Module.Import
