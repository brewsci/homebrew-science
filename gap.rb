class Gap < Formula
  desc "System for computational discrete algebra"
  homepage "http://www.gap-system.org/"
  url "http://www.gap-system.org/pub/gap/gap48/tar.bz2/gap4r8p4_2016_06_04-12_41.tar.bz2"
  version "4.8.4"
  sha256 "f394bb4c5f24c662ba5ef1674e6c3d7565e31e60fc7e37c7b0f7e5208e029828"

  bottle do
    cellar :any
    sha256 "5592f3f365905cfe3989ea9498c8aef785d3c9195051884b2898d7fa9df31165" => :el_capitan
    sha256 "9f2ac0862296062c2bfceeb3834e81626843a7c6e3c2f20e13b009f125cb39a6" => :yosemite
    sha256 "9aab0786812ffcc15eec79265b03970913b90551c1ccec5ebad6c41b41315624" => :mavericks
  end

  # NOTE:  the archive contains the [GMP library](http://gmplib.org) under
  #   `extern/`, which is not needed if it is already installed (for example,
  #   with Homebrew), and a number of GAP packages under `pkg/`, some of
  #   which need to be built.

  option "with-packages",
         "Try to build included packages using BuildPackages script"

  deprecated_option "with-InstPackages" => "with-packages"

  depends_on "gmp"
  # NOTE:  A version of [GMP](https://gmplib.org) is included in GAP archive
  #   under `extern/`, it is possible to use it instead of the brewed `gmp`.
  #   See http://www.gap-system.org/Download/INSTALL for details.

  depends_on "readline" => :recommended

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

    if build.with? "packages"
      ohai "Trying to automatically build included packages"
      cd libexec/"pkg" do
        # NOTE:  running this script is known to produce a number of error
        #   messages, possibly failing to build certain packages
        system "../bin/BuildPackages.sh"
      end
    end
  end

  # XXX:  `brew info` displays the caveats according to the options it is
  #   given, not according to the options with which the formula is installed
  def caveats
    if build.without?("packages")
      <<-EOS.undent
        If the formula is installed without the `--with-packages' option,
        some packages in:
          #{libexec/"pkg"}
        will need to be built manually with the following script:
          #{libexec/"bin/BuildPackages.sh"}
        See the Section 7 of #{libexec/"INSTALL"} for more info.
      EOS
    else
      <<-EOS.undent
        When the formula is installed with the `--with-packages' option,
        some packages in
          #{libexec/"pkg"}
        are automatically built using the following script:
          #{libexec/"bin/BuildPackages.sh"}
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
