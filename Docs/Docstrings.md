# Docstrings in LibPQ

The idea of a docstring is nothing new ([Java][javadoc], [Python][docstring]),
yet Power Query does not offer any simple convention for documenting your code.
There is a way to view function documentation in user interface, but adding
documentation to custom functions is not exactly a straightforward process (see
[Microsoft documentation][ms-function-docs] or blog posts by [Imke
Feldman][imkef-metadata] and [Lars Schreiber][ssbi-metadata]).

LibPQ enables support for basic docstrings in source code modules. It will
automatically convert these docstrings into correct metadata that will be
visible from Power Query / PowerBI user interface.

A docstring for LibPQ is a comment that meets the following requirements:

- Docstring must be written as a *delimited comment* (enclosed in `/*` and
  `*/`).
- Docstring must be placed at the top of the source code module. There must be
  no code or comments before the docstring.
- There must be no nested delimited comments inside the docstring.

Such comments will be automatically converted into proper metadata by LibPQ and
will become available via user interface. See example below.

## Docstring demo

This is a demo module `HelloWorld.pq`:
```javascript
/*
Hello world function (demo of LibPQ docstrings)

Multiline docstrings are supported

There is also support for <i>basic <b>HTML</b></i> formatting (implemented by
Power Query / PowerBI itself, this is not a LibPQ feature)

LibPQ will also add information about the location of source code for this
module, see below.
*/

(hello) => hello & " world!"
```

It will be shown in the UI like this:

![Docstring demonstration][demo]

[docstring]: https://en.m.wikipedia.org/wiki/Docstring
[javadoc]: https://en.m.wikipedia.org/wiki/Javadoc
[ms-function-docs]: https://github.com/Microsoft/DataConnectors/blob/master/docs/function-docs.md
[imkef-metadata]: http://www.thebiccountant.com/2017/05/11/how-to-edit-m-function-metadata/
[ssbi-metadata]: https://ssbi-blog.de/technical-topics-english/writing-documentation-for-custom-m-functions-part1/
[demo]: DocstringsDemo.png
