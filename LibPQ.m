/******************
   UNFINISHED!!!
******************/

/**
LibPQ:
    Access all components of the library as a record.
**/

let
    /* Temporary sample inputs */
    Directory = "C:\Users\Виталий\Desktop\LibPQ\Functions\",
    File = "C:\Users\Виталий\Desktop\LibPQ\Functions\fnReadParameters.m",
    Url = "https://raw.githubusercontent.com/tycho01/pquery/master/Load.pq",

    /* Constants */
    EXTENSION = ".m",
    PATHSEPLOCAL = "\",
    PATHSEPREMOTE = "/",

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
    Function.FromPath = (path as text, optional local as logical) =>
        Expression.Evaluate(Text.Load(path, local), #shared),

    /* Calculate where the function code is located */
    Function.GetPath = (funcname as text, directory as text, optional local as logical) =>
        let
            /* Defaults */
            Local = if local is null then true else local,
            PathSep = if Local then PATHSEPLOCAL else PATHSEPREMOTE,

            /* Path building */
            ProperDir = if Text.EndsWith(directory, PathSep)
                        then directory
                        else directory & PathSep,
            ProperName = Text.Replace(funcname, "_", "."),
            Return = ProperDir & ProperName & EXTENSION
        in
            Return,


    /* Playground */
    Dirs = {Directory, "C:\Users\Виталий\Desktop\Номенклатура", "M:\Виталий Потяркин"},
    Files = List.Generate(
        () => [i = -1, results = 0],
        each [i] < List.Count(Dirs),
        each [
            i = [i]+1,
            files = if [results] > 0
                    then #table({"Extension"},{})  // empty table
                    else Folder.Contents(Dirs{i}),
            filter = Table.SelectRows(
                        files,
                        each [Extension] = EXTENSION
                    ),
            results = if [results] > 0
                      then [results]  // break the loop
                      else Table.RowCount(filter),
            functions = List.Transform(
                            filter[Name],
                            each Text.BeforeDelimiter(
                                _,
                                EXTENSION,
                                {0,RelativePosition.FromEnd}
                            )
                        )
        ]
    ),
    Functions = List.Skip(Files, each [results]=0){0}[functions],
    ReturnDebug = Functions,


    /* Last touch: export helper functions defined above */
    Helpers = [
        Text.Load = Text.Load,
        Function.FromPath = Function.FromPath,
        Function.GetPath = Function.GetPath
    ],
    Library = "A record with all loaded functions", // TODO
    Return = Record.Combine({Helpers, Library})
in
    ReturnDebug