### Have you:

- [ ] Followed the guidelines in our [Contributing](https://github.com/Homebrew/homebrew-science/blob/master/.github/CONTRIBUTING.md) document?
- [ ] Checked to ensure there aren't other open [Pull Requests](https://github.com/Homebrew/homebrew-science/pulls) for the same update/change?
- [ ] Run `brew audit --strict --online <formula>` (where `<formula>` is the name of the formula you're submitting) and corrected all errors?
- [ ] Built your formula locally prior to submission with `brew install <formula>`?

### New formula:

We will no longer accept new formula in homebrew-science, as this tap is being phased out.
Please consider submitting your formulae to https://github.com/Homebrew/homebrew-core or host it in your own tap (https://docs.brew.sh/How-to-Create-and-Maintain-a-Tap.html).

### Updates to existing formula: have you

- [ ] Removed the `revision` line, if any, when bumping the version number?
- [ ] Added/bumped the `revision` number if the changes affect the precompiled bottles?
- [ ] Not altered the `bottle` section?
- [ ] Checked that the tests still pass?
