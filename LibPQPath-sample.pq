/**
LibPQPath:
    Places where LibPQ will search for modules.

    Local sources have priority over Web sources.
    Local and Web locations must be listed in the priority order: from
    high to lower priority.
**/

[
    Local = {
        "C:\PQuery",
        "D:\PQuery"
    },
    Web = {
        "https://raw.githubusercontent.com/sio/LibPQ/master/Modules/",
        "https://raw.githubusercontent.com/tycho01/pquery/master/"
    }
]