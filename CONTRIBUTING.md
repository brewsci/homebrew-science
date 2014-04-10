First of all, thank you for contributing to Homebrew/Science. The following guidelines are designed to help you write more efficient pull requests and / or issues.


## Formula Guidelines

Please first read the [Formula Cookbook](https://github.com/mxcl/homebrew/wiki/Formula-Cookbook). This section lists additional guidelines that should be followed in Homebrew/Science.

### Tests

We insist that formulae in Homebrew/Science always be accompanied by tests. Not all formulae currently in Homebrew/Science have meaningful tests but the idea is to improve them over time.

Tests can be in the form of a `make test` or `make check`, a `test` method, or (if possible) both. If your package doesn't provide tests, that should be specified in the pull request. As a last resort, it is often possible to run one or more installed executables in a `test` method (e.g., `system "foo", "-v"`), but meaningful tests should be preferred.

If tests involve downloading a (small) data set, that's fine.

Whenever install-time tests in the form of `make test` or `make check` take more than a few seconds, an option offering to disable tests should be included. Running the tests should be the default behavior. Use the option `without-check` to disable your build-time tests. See [Testing / Checking](#testing--checking).

### Logical Guidelines

* Group mandatory, optional, and recommended dependencies together
* Group other options together
* Patches should have been submitted upstream, or should be documented (e.g., a reference to MacPorts or Debian)

### Stylistic Guidelines

* Follow the [GitHub Ruby Styleguide](https://github.com/styleguide/ruby)
* Remove unnecessary blank lines and all trailing whitespace
* Use inline `if` and `unless` whevener possible and reasonable (e.g., `depends_on "foo" if build.with? "bar"`, `system "make", "check" if build.with? "check"`)
* Use two spaces to indent, no tabs.


## Submitting a Pull Request

### Checklist

* Strictly one pull request per formula.
* Strictly one formula per pull request.
* When modifying an existing formula, avoid cluttering the patch with unnecessary changes
* Please check [open pull requests](https://github.com/Homebrew/homebrew-science/pulls) before submitting a new pull request. Duplication slows down acceptance of pull requests and confuses users and maintainers. Duplicate pull requests will be closed.
* Fix anything reported by `brew audit foo` when you submit `foo.rb`.

### New Pull Requests

* If your formula is *head only*, i.e., no stable archives are provided for download by the developers, it should be submitted to Homebrew/headonly. It will not be merged in Homebrew/Science.
* Please give your pull request an informative title. Each pull request title and commit message should start with the name of the formula, followed by a colon and space. New upstream versions should start with the formula name followed by a space and the version number, and optionally followed by a colon, space and comment. For example:
    - `boo`: new formula.
    - `foo` 1.2.3: optional comment.
    - `bar`: fixing download URL.
    - `gargl`: updating sha1.
    - `blah`: add `test` method.
* Please keep the commit message to a minimum. Github lets you describe your pull request at length when you submit it.
* Patches should have been submitted upstream, or should be documented (e.g., a reference to MacPorts or Debian). Include a link to the upstream issue or conversation.
* Be sure to include a `make test` / `make check` if available. If the test or check takes more that a few seconds, a `--without-check` option should be available to disable it. The test or check must be enabled by default.
* If possible, include a `test` method. And if possible, the test method should be more thorough than just printing the binary's version or help message.

### Pull Request vs. Tap

In some cases, it may make more sense for you to host a Homebrew tap than to include your formula(e) in Homebrew/Science. Here are a few guidelines to keep in mind when making your decision.

Hombrew/Science may give your formula wider visibility but a tap may be preferable when :

* Your formula is part of a group of specialized and/or related formulae.
* The source code or releases are very frequent so that the formula(e) must be updated frequently.
* Your formula should be brewable urgently.

Remember, it's always ok to start with your own tap and submit to Homebrew/Science later.

### Will My Pull Request Be Merged?

Probably, but please pay attention to the points above. The more careful you are with your code, the smoother the process will be.

If it takes a while for us to get back to you, relax. We work on Homebrew/Science on our own time. We're glad you're contributing and we'll do our best to keep you waiting as little as possible. It's fine to ping us to remind us of your request after a few days.

We're working on our backlog and trying to pull older requests and resolve older issues. That may also explain why we're taking a bit longer to get to your request.

If you'd like your formula(e) to be brewable urgently, the best option may be for you to host your own tap, even if it's temporary.


## Issues

### Checklist

* Strictly one formula per issue unless your issue is about different formulae interacting negatively.
* Please check [open](https://github.com/Homebrew/homebrew-science/issues?state=open) and [closed](https://github.com/Homebrew/homebrew-science/issues?page=1&state=closed) issues before submitting a new issue. Duplication slows down issue resolution and confuses users and maintainers. Answers given to existing issues may already resolve your difficulties. Duplicate issues will be closed.
* Carefully check the output of `brew doctor`. The suggestions given there may very well resolve your difficulties. In particular, check conflicts with Macports and/or Fink.
* We may be connected on the `#machomebrew` IRC channel. Please check there before opening a new issue.

### New Issues

* If a formula fails to brew or if tests fail, always [gist](https://gist.github.com) the log files ; they can be found under `~/Library/Logs/Homebrew/`*formula_name* or recreated with `brew install -v foo`.
* Always give the full `brew` command that you used and that caused the error to emerge.
* Generate a gist with `brew gist-logs --config --doctor foo` and provide links in your issue.

For more about gists, see https://help.github.com/articles/creating-gists and https://github.com/defunkt/gist.


## Useful Snippets and Notes

### Optional Dependencies

Homebrew provides the symbols `:optional` and `:recommended` to allow for inclusion / exclusion of optional dependencies. If the dependency `foo` is marked as `:optional`, it is excluded by default and may be included using `--with-foo` on the command line. If `foo` is marked as `:recommended`, it is included by default and may be excluded by using `--without-foo` on the command line.

Thus, the following

    option "with-foo"
    depends_on "foo" if build.with? "foo"

is redundant and should be replaced with the simpler and more readable

    depends_on "foo" => :optional

### Locating Dependencies

There is no good reason to refer to `HOMEBREW_PREFIX` in a formula. Please keep in mind that dependencies may be unlinked at build time. Brew will complain if a dependency is unlinked but that is a historical remnant that is probably bound to disappear. If you need to refer to the location of libraries or header files, please use `Formula["foo"].lib`,  `Formula["foo"].include`, `Formula["foo"].opt_prefix`, etc.

### Testing / Checking

This should become a classic:

    option "without-check", "Disable build-time checking (not recommended)"
    ...
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"

### Building in a 64 Bit Environment

    ENV.m64 if MacOS.prefer_64_bit?

### Ternary Operator

The one-liners

    arch = MacOS.prefer_64_bit? ? "macosx64" : "macosx"

and

    arch = if MacOS.prefer_64_bit? then "macosx64" else "macosx" end

should be preferred to the multi-line `if` block, and, with a little habit, are more readable.

### OpenMP

The current version of Clang, which is the default C compiler used in Homebrew, doesn't support OpenMP, but GCC does. Here's an example of alerting the user that OpenMP will not be enabled if using Clang:

    opoo "Clang does not support OpenMP. Compile with gcc if this is not acceptable." if ENV.compiler == :clang

This snippet will not abort compilation but output a warning message.

### MPI

Please do not duplicate options for enabling MPI in a formula. For instance

    option "with-mpi"
    depends_on :mpi => [:f90, :c, :cxx] if build.with? "mpi"

is redundant and should be replaced with

    depends_on :mpi => [:f90, :c, :cxx, :optional]

Depending on `:mpi` is more flexible than depending directly on `mpich2` or `open-mpi`. Remember that users could have installed either and that the two `conflict_with` each other.

### Checking What Options Were Used to Build a Dependency

    nprocs = (Tab.for_formula("foo").used_options.include? "without-mpi") ? 1 : 2

This can come in handy in `test` methods, where build options are not visible:

    def test
      nprocs = (Tab.for_formula(self).used_options.include? "without-mpi") ? 1 : 2
      ...
    end
    
### Optionally Depending Upon X11

    depends_on :x11 => MacOS::X11.installed? ? :recommended : :optional

## Suggestions?

Issues may also be used to suggest improvements to this wiki. If you're willing to add a new section to this documentation, we would very much welcome your contribution. Please create a gist with your prose and open an issue pointing us to it.