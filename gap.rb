class Gap < Formula
  desc "A system for computational discrete algebra"
  homepage "http://www.gap-system.org/"
  url "ftp://ftp.gap-system.org/pub/gap/gap47/tar.bz2/gap4r7p9_2015_11_29-20_35.tar.bz2"
  version "4.7.9"
  sha256 "0673b98f2f9246e9e10ef63ea8b3b359026a9219a5912dccde8d24bf6bec373c"

  bottle do
    cellar :any
    sha256 "38f6a96e73384f00a71d476e7f720a14b50e0336cad92d2b709ba54d54cc9a5d" => :el_capitan
    sha256 "19a28ee70894a15ecc0754b0d3ff1d052e1e21b166e45a02158b826c84df2617" => :yosemite
    sha256 "599610482277ee7aaeaa481f25bd541fafcbb9e572fca4fd7d9ee0be6d39538c" => :mavericks
  end

  # NOTE:  the archive contains the [GMP library](http://gmplib.org) under
  #   `extern/`, which is not needed if it is already installed (for example,
  #   with Homebrew), and a number of GAP packages under `pkg/`, some of
  #   which need to be built.

  option "with-InstPackages",
         "Try to build included packages using InstPackages script"

  depends_on "gmp"
  # NOTE:  A version of [GMP](https://gmplib.org) is included in GAP archive
  #   under `extern/`, it is possible to use it instead of the brewed `gmp`.
  #   See http://www.gap-system.org/Download/INSTALL for details.

  depends_on "readline" => :recommended

  INST_PACKAGES_SCRIPT_URL = "http://www.gap-system.org/Download/InstPackages.sh"

  resource "script_that_builds_included_packages" do
    url INST_PACKAGES_SCRIPT_URL
    sha256 "2749cc6736bde594f3dc35bbbb644511efc18c83991d07fbac15f86b7d986505"
  end

  def install
    # Remove some useless files
    rm Dir["bin/*.bat", "bin/*.ico", "bin/*.bmp", "bin/cygwin.ver"]

    # Remove GMP archives (`gmp` formula is declared as a dependency)
    rm Dir["extern/gmp-*.tar.gz"]

    # XXX:  Currently there is no `install` target in `Makefile`.
    #   According to the manual installation instructions in
    #
    #     http://www.gap-system.org/Download/INSTALL ,
    #
    #   the compiled "bundle" is intended to be used "as is," and there is
    #   no instructions for how to remove the source and other unnecessary
    #   files after compilation.  Moreover, the content of the
    #   subdirectories with special names, such as `bin` and `lib`, is not
    #   suitable for merging with the content of the corresponding
    #   subdirectories of `/usr/local`.  The easiest temporary solution seems
    #   to be to drop the compiled bundle into `<prefix>/libexec` and to
    #   create a symlink `<prefix>/bin/gap` to the startup script.
    #   This use of `libexec` seems to contradict Linux Filesystem Hierarchy
    #   Standard, but is recommended in Homebrew's "Formula Cookbook."

    args = %W[--prefix=#{libexec} --with-gmp=system]

    args << "--#{build.with?("readline") ? "with" : "without"}-readline"
    # NOTE: `--with-readline` is the default, it is included for clarity

    system "./configure", *args

    # Fix a bug caused by the buggy `configure` which does not respect
    # `--prefix` when generating the startup script: the variable `GAP_DIR`
    # is being set to the (temporary) build directory, but should be set to
    # the value of `--prefix` option.
    ["bin/gap-default32.sh", "bin/gap-default64.sh"].each do |startup_script|
      next unless File.exist?(startup_script)
      inreplace startup_script, /^GAP_DIR="[^"]*"$/,
                                        "GAP_DIR=\"#{libexec}\""
    end

    system "make"

    libexec.install Dir["*"]

    # Create a symlink `bin/gap` from the symlink `gap.sh`
    cd libexec/"bin" do
      # NOTE: the symbolic link `gap.sh` is (or may be) relaive
      bin.install_symlink File.expand_path(`readlink -n gap.sh`) => "gap"
    end

    if build.with? "InstPackages"
      ohai "Trying to automatically build included packages"

      resource("script_that_builds_included_packages").stage do
        chmod "u+x", "InstPackages.sh"
        (libexec/"pkg").install "InstPackages.sh"
      end

      cd libexec/"pkg" do
        # NOTE:  running this script is known to produce a number of error
        #   messages, possibly failing to build certain packages
        system "./InstPackages.sh"
      end
    end
  end

  # XXX:  `brew info` displays the caveats according to the options it is
  #   given, not according to the options with which the formula is installed
  def caveats
    if build.without?("InstPackages")
      <<-EOS.undent
        If the formula is installed without the `--with-InstPackages' option,
        some packages in:
          #{libexec/"pkg"}
        will need to be built manually with the following script:
          #{INST_PACKAGES_SCRIPT_URL}
        See the Section 7 of #{libexec/"INSTALL"} for more info.
      EOS
    else
      <<-EOS.undent
        When the formula is installed with the `--with-InstPackages' option,
        some packages in
          #{libexec/"pkg"}
        are automatically built using the following script:
          #{INST_PACKAGES_SCRIPT_URL}
        However, this script is known to produce a number of error messages,
        and thus it might have failed to build certain packages.
      EOS
    end
  end

  test do
    File.open("test_input.g", "w") do |f|
      f.write <<-EOS.undent
        Print(Factorial(3), "\\n");
        Print(IsDocumentedWord("IsGroup"), "\\n");
        Print(IsDocumentedWord("MakeGAPDocDoc"), "\\n");
        QUIT;
      EOS
    end
    test_output = `#{bin/"gap"} -b test_input.g`
    assert_equal 0, $?.exitstatus
    expected_output =
      <<-EOS.undent
        6
        true
        true
      EOS
    assert_equal expected_output, test_output
  end
end
