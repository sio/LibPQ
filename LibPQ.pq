/**
LibPQ:
    Access Power Query functions and queries stored in source code modules
    on filesystem or on the Web.

Project website:
    https://libpq.ml

This code was last modified on 2019-10-11

Timestamp in docstring is necessary for further updating, because this code
will be copied into the workbook and will be managed manually afterwards.
**/

let
    /* Read LibPQ settings */
    Sources.Local = LibPQPath[Local],
    Sources.Web   = LibPQPath[Web],

    /* Constants */
    EXTENSION = ".pq",
    PATHSEPLOCAL = Text.Start("\\",1),
    PATHSEPREMOTE = "/",
    ERR_SOURCE_UNREADABLE = "LibPQ.ReadError",
    DESCRIPTION_FOOTER = (path) =>
        "<br><br>" &
        "<i><div>" &
        "This module was loaded with LibPQ: https://github.com/sio/LibPQ" &
        "</div><div>" &
        "Module source code: " &
        path &
        "</div></i>",

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

    /*
    Read the first multiline comment from the source code in Power Query
    Formula language (also known as M language). That comment is considered a
    docstring for LibPQ
    */
    Read.Docstring = (source_code as text) =>
    let
        Docstring = [
            start = "/*",
            end = "*/"
        ],
        DocstringDirty = Text.BeforeDelimiter(
            source_code,
            Docstring[end]
        ),
        BeforeDocstring = Text.BeforeDelimiter(
            DocstringDirty,
            Docstring[start]
        ),
        MustBeEmpty = Text.Trim(BeforeDocstring),
        DocstringText =
            if
                Text.Length(MustBeEmpty) = 0
            then
                Text.Trim(DocstringDirty, {"*", "/", " ", "#(cr)", "#(lf)", "#(tab)"})
            else
                ""
    in
        DocstringText,

    /*
       Load Power Query function or module from file,
       return null if destination unreadable
    */
    Module.FromPath = (path as text, optional local as logical, optional name as text) =>
        let
            SourceCode = try Read.Text(path, local)
                         otherwise "null",
            LoadedObject = Expression.Evaluate(SourceCode, #shared),
            LoadTry = try LoadedObject,
            CustomError = Record.TransformFields(
                LoadTry[Error],
                {"Detail", each CustomErrorDetail}
            ),
            CustomErrorDetail = [
                Original = LoadTry[Error][Detail],
                LibPQ = ExtraMetadata
            ],
            ExtraMetadata = [
                LibPQ.Module = name,
                LibPQ.Source = path,
                LibPQ.Docstring = Read.Docstring(SourceCode),
                Documentation.Name = LibPQ.Module,
                Documentation.Description =
                    Text.Replace(LibPQ.Docstring, "#(lf)", "<br>") &
                    DESCRIPTION_FOOTER(path)
            ],
            OldMetadata = Value.Metadata(LoadedObject),
            TypeMetadata = Value.Metadata(Value.Type(LoadedObject)),
            Module = Value.ReplaceType(
                try LoadedObject otherwise error CustomError,
                Value.ReplaceMetadata(
                    Value.Type(LoadedObject),
                    Record.Combine({ExtraMetadata, TypeMetadata})
                )
            ) meta Record.Combine({ExtraMetadata, OldMetadata})
        in
            Module,

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
                () => [
                    i = -1,
                    object = null,
                    lasterror = null
                ],
                each [i] < List.Count(Paths),
                each [
                    // `load` should be evaluated only if absolutely necessary.
                    // If path is unreadable, no error is raised but null value
                    // is returned (see Module.FromPath)
                    load = try Module.FromPath(Paths{i}, local, name),
                    object = if [object] is null and not load[HasError]
                             then load[Value]
                             else [object],
                    lasterror = if [object] is null and load[HasError]
                                then load[Error]
                                else [lasterror],
                    i = [i] + 1
                ]
            ),
            Return = try
                        List.Select(Loop, each [object] <> null){0}[object]
                     otherwise
                        error if List.Last(Loop)[lasterror] <> null
                              then List.Last(Loop)[lasterror]
                              else Error.Record(
                                    ERR_SOURCE_UNREADABLE,
                                    "Module not found: " & name
                                   )
        in
            Return,

    /* Import a module from default locations (LibPQPath) */
    Module.Import = (name as text) =>
        let
            Attempts = {
                // {expression, silent errors}
                {Record.Field(#shared, Module.NameFromProper(name)), true},
                {Record.Field(#shared, Module.NameToProper(name)), true},
                {Record.Field(Helpers, name), true},
                {Module.ImportAny(name, Sources.Local), false},
                {Module.ImportAny(name, Sources.Web, false), false}
            },
            Results = List.Last(List.Generate(
                () => [
                    i = -1,
                    module = null,
                    error = null
                ],
                each [i] < List.Count(Attempts),
                each [
                    i = [i] + 1,
                    load = try Attempts{i}{0},
                    error = if
                                [module] is null and
                                not Attempts{i}{1} and
                                load[HasError] and
                                load[Error][Reason] <> ERR_SOURCE_UNREADABLE
                            then
                                load[Error]
                            else
                                [error],
                    module = if
                                [module] is null and
                                not load[HasError]
                             then
                                load[Value]
                             else
                                [module]
                ]
            )),
            Module = if Results[module] <> null
                     then Results[module]
                     else if Results[module] is null and Results[error] <> null
                     then error Results[error]
                     else error Error.Record(
                        ERR_SOURCE_UNREADABLE,
                        "Module not found: " & name
                     )
        in
            Module,

    /* Last touch: export helper functions defined above */
    Helpers = [
        Read.Text = Read.Text,
        Read.Docstring = Read.Docstring,
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
