/**
LibPQPath:
    Places where LibPQ will search for modules.

    Local sources have priority over Web sources.
    Local and Web locations must be listed in the priority order: from
    high to lower priority.
**/

[
    Local = {
        "C:\ExtractLocation\LibPQ\Modules",
        "C:\ExtractLocation\LibPQ\Tests",
        "D:\ExtractLocation\LibPQ\Modules",
        "D:\ExtractLocation\LibPQ\Tests"
    },
    Web = {
        "https://github.com/sio/LibPQ/raw/master/Modules/",
        "https://github.com/tycho01/pquery/raw/master/",
    }
]
