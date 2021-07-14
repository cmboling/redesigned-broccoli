# quickjavahelloworld

This repository contains an example of a "hello world" java application along with a known non-best practice java coding example of concatenating loops in a string.

The original idea was to understand how we can get both the `codeql-runner-*` and `codeql` CLI tools to work with [bazel](https://bazel.build/)

There is also a custom query at `/my-basic-queries`, to pick up the loop string concatenation. This gives a base example on how to include custom queries. The query itself is just a copy of the standard one at https://github.com/github/codeql/blob/main/java/ql/src/Performance/ConcatenationInLoops.ql but with a custom `@id java/affraes-string-concatenation-in-loop` so we can see it being picked up in analysis.

## Notes
There is a bug in the current public build of the `codeql` CLI tool that does not pass on all the required environment variables to `bazel`. This is fixed in a bleeding edge build of `codeql` - the tool and bundle for which is contained in `/codeqlbinaries` (in OS-specific sub-directories). The scripts use this bundle where necessary. It is expected this build will see light of day in the 2.5.1 release.

## Setup

You will need to have `bazel` installed on your system and available in your $PATH.

- On a mac you can do this with [homebrew](https://brew.sh) and the command `brew install bazel`

You will also need the OS specific `codeql-runner` for your platform (eg `codeql-runner-macos` or `codeql-runner-linux`) available in your $PATH. See https://docs.github.com/en/code-security/secure-coding/running-codeql-code-scanning-in-your-ci-system#downloading-the-codeql-runner for further details

A setup script is forthcoming.

## Scripts (tested on macOS, not tested on linux, not written for win support, yet)

- `mvnexec.sh` - just does a maven `build`, `package` and `exec` process. Does not do anything involving `bazel` or `codeql`
- `javacbuild.sh` - uses `javac`. Performs a `codeql-runner-* init` and `analyze` (with no uploading of results). Usage: `./javacbuild.sh`
- `clibazel.sh` - uses the `codeql` CLI tool to create a CodeQL database using `bazel` as the build tool. Usage: `./clibazel.sh`
- `bazelbuild.sh` - uses `bazel`. Performs a `codeql-runner-* init` and `analyze` (with no uploading of results). Usage: `./bazelbuild.sh`


## Workflows

There is a standard `codeql-analysis.yml` GtHub Actions workflow file that autobuilds and analyzes so you can see this in GitHub Actions without using `bazel`

In addition, there is a `codeql-build.yml` workflow that simply uses a GitHub Actions-supplied Linux VM to execute a codeql database build with `bazel`. This, however, uses the latest publicly available version of the `codeql` CLI tool and will currently break until the fix is released, but is included so you can get an idea of how it would work.
