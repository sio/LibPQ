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
  future (that must always be documented in [release notes] and must be reflected
  in the release [version number][SemVer]).
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


## Release 1.0 roadmap
- Fix issue #7
- Add release notes (markdown file, in root directory)
    - File name: RELEASES or CHANGELOG?
    - Keep release dates
    - Link git commit range
    - Newest releases on top of the file, [Unreleased] section for changes
      after the last release
    - Add a short description on top
        - Mention that the project follows semantic versioning https://semver.org/
        - Link to http://keepachangelog.com
    - Structured description
    - Release notes sections:
        - Added (features and improvements)
        - Changed
        - Deprecated
        - Removed
        - Fixed
        - Security


[SemVer]: https://semver.org/
[release notes]: RELEASES.md
