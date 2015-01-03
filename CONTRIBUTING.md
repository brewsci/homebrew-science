# Contributing
Thank you for your interest in contributing to [Homebrew/science]. The following guidelines are designed to help you write more efficient pull requests.

## Formula Guidelines
Read Homebrew's [Formula Cookbook] and [Acceptable Formulae]. If your formula installs or depends on Python modules you may want to read [Python for Formula Authors] as well.

Please **follow the [GitHub Ruby Styleguide]**.

#### Patches
Homebrew provides DSL for applying diff patches appended to the end of formula file, or as remote files (e.g. a gist). In most cases, patches should be submitted upstream and linked to in your comments.

#### Tests
All formulæ should be accompanied by tests. We greatly appreciate any submissions that improve individual tests and test coverage in Homebrew/science.

The `test do` block allows for a post-build test of software functionality sandboxed within a temporary `testpath`. For example, a test program may be written and compiled, and its output checked against an expected value. Meaningful tests are preferred over simple commands like `system "foo", "-v"`.

`make check` or equivalent should be enabled if the package provides it. This should become a classic:

    option "without-check", "Disable build-time checking (not recommended)"
    ...
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"

If this target takes an inordinate amount of resources or is otherwise problematic the option can be switched to `"with-check"`, which will disable checking in the default build.

## Submitting a Pull Request
First read core Homebrew's [How To Open a Homebrew Pull Request (and get it merged)]. The Homebrew/science tap repository is located in `$(brew --repository)/Library/Taps/homebrew/homebrew-science`.

Check [open pull requests] before submitting a duplicate. We prefer one formula per PR.

Start you commit messages with a short informative summary, prefaced by the formula name:
* `foo: add test`
* `bar: make X11 optional`
Version upgrades should just be titled with their version:
* `baz 2.4.1`
* `qux 0.1.2 (new formula)`

Use the rest of the commit message to describe your changes and link to any relevant issues. When your submission is ready to merge, squash all your commits to a single commit and push to your remote branch, with `--force` if necessary.

## Pull Request vs. Tap
Anyone can host their own [tap]. Homebrew/science may give your formula wider visibility but a tap is preferable when:
* Your formula must be brewable urgently.
* It is part of a group of specialized and/or related formulæ.
* It is head-only or lacks a stable tagged release.

Feel free to start your own tap and submit to Homebrew/science later.

## Useful Snippets and Notes
#### Linking Dependencies
Avoid refering to `HOMEBREW_PREFIX` in a formula. If you need to refer to other libraries or header files, use stable `opt` paths: `Formula["foo"].opt_prefix`, `Formula["foo"].opt_lib`,  `Formula["foo"].opt_include`, etc.

#### OpenMP
The current version of Clang, which is the default C compiler used in Homebrew, doesn't support OpenMP, but GCC does. Here's an example of alerting the user that OpenMP will not be enabled if using Clang:

    opoo "Clang does not support OpenMP. Compile with gcc if this is not acceptable." if ENV.compiler == :clang

This snippet will not abort compilation but output a warning message.

formulæ which require OpenMP support should specify

    needs :openmp

#### MPI
Depending on `:mpi` is more flexible than depending directly on `mpich2` or `open-mpi`. Remember that users could have installed either and that the two `conflict_with` each other.

#### Checking What Options Were Used to Build a Dependency

    nprocs = Tab.for_formula("foo").without?("mpi") ? 1 : 2

## Suggestions
Improvements to this guide are appreciated via issues or pull requests. If you're willing to add a new section to this documentation or the wiki, we would very much welcome your contribution.

[Homebrew/science]: https://github.com/Homebrew/homebrew-science
[open pull requests]: https://github.com/Homebrew/homebrew-science/pulls
[How To Open a Homebrew Pull Request (and get it merged)]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/How-To-Open-a-Homebrew-Pull-Request-(and-get-it-merged).md
[tap]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Interesting-Taps-%26-Branches.md#interesting-taps--branches
[GitHub Ruby Styleguide]: https://github.com/styleguide/ruby
[Formula Cookbook]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
[Acceptable Formulae]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Acceptable-Formulae.md
[Python for Formula Authors]: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Python-for-Formula-Authors.md