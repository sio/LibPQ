# Automated unit test execution and error reporting

This directory contains code used by continuous integration [pipelines] to
non-interactively execute LibPQ unit tests and to report detected test failures.

## Usage

To execute tests manually run `make verify` in this directory.

## Dependencies

The following tools are required to execute LibPQ unit tests
non-interactively:

- [PowerQueryNet]: the most important tool behind LibPQ test automation. It
  allows us to execute Power Query outside of Excel/PowerBI and provides
  commandline entrypoint for non-interactive use
- [GNU Make]: provides nice interface to orchestrate other CLI tools and to
  manage dependencies between automation steps
- [Python 3]: powers a [simple script][verify.py] that verifies test results
  and reports errors
- [envsubst] from gettext utils: a simple templating engine for configuration
  files used by other tools. This utility is usually automatically installed
  along with Unix-like userland (MSYS, Cygwin, WSL)

[GNU Make]: https://www.gnu.org/software/make/
[PowerQueryNet]: https://github.com/gsimardnet/PowerQueryNet
[Python 3]: https://www.python.org/
[envsubst]: https://www.gnu.org/software/gettext/manual/html_node/envsubst-Invocation.html
[pipelines]: https://github.com/sio/LibPQ/actions
[verify.py]: verify.py
