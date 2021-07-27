# Plans and ideas for LibPQ development


## Project vision and values

LibPQ project was created to enable importing Power Query M language source
code from plain text files located on file system or on the remote web server.
As of version 1.0.0 that goal is achieved, but LibPQ development continues.

Current goals and values (in order of descending importance) are:

- **Maintaining LibPQ loader**. This is the core functionality of LibPQ and it
  must remain fully operational in future versions of Power Query / PowerBI.
- **Ensuring backwards compatibility**. LibPQ is there for other developers to
  use, and we should not interfere with the code they've built upon ours. This
  applies most strictly to the loader and the modules essential for internal
  use (e.g. UnitTest framework), other modules may see some breaking changes in
  future (that must always be documented in [release notes](RELEASES.md) and
  must be reflected in the release [version number](https://semver.org/)).
- **Improving import-time user experience**. LibPQ already offers local module
  listing, parses module docstrings for viewing in the UI and correctly relays
  errors in modules' code, but there must be other methods to improve module
  discoverability and simplify their usage. If such methods are to be found,
  their implementation will be added to LibPQ development roadmap.
- **Extending the collection of useful modules**. LibPQ allows anyone to start
  their own library of pre-recorded functions and queries. That library can be
  easily incorporated into any other workbook or report that uses LibPQ. That's
  why extending the collection of modules and functions that's packaged with
  LibPQ has the lowest priority. Only the most widely useful modules that solve
  the most general problems will be added to the Modules/ directory.
  Domain-specific collections of functions and queries are better suited for a
  separate project that relies on LibPQ for importing the source code.


## Roadmap to the next release (probably 1.4.0)

There are no explicit plans for new features yet. This section will be futher
updated in the development process. If you think something needs to be added
or changed in LibPQ, please feel free to create [an
issue](https://github.com/sio/LibPQ/issues).

If no critical bugs are discovered and no breaking changes arrive with Power
Query updates, the next (minor) release will most likely happen in 2022.
