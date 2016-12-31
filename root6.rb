class Root6 < Formula
  # in order to update, simply change version number and update sha256
  version_number = "6.08.02"
  desc "Object oriented framework for large scale data analysis"
  homepage "https://root.cern.ch"
  url "https://root.cern.ch/download/root_v#{version_number}.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v#{version_number}.source.tar.gz"
  version version_number
  sha256 "131c50a81e72a1cd2b2825c66dbe3916c23b28006e84f5a028baed4c72d86014"

  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "2a6cc29e06d90e1bbca848b06844263ba692e3edc482c279cfcdfb2073a6e5f2" => :sierra
    sha256 "5de820b6d8d37d36962bc57a4f8f0ce4febd06c0bb7ad5bfadf59e5f0d6847f4" => :el_capitan
    sha256 "da8baf9db5a25c18edbc634794cbca3b773fe22b517ab1a734ff4d5bb1ae2253" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "xrootd" => :optional
  depends_on "fftw" => :optional
  depends_on "openssl" => :recommended # use homebrew's openssl
  depends_on :python => :recommended # make sure we install pyroot
  depends_on :x11 => :recommended if OS.linux?
  depends_on :fortran => :recommended # enabled by default since 6.08.00
  depends_on "gsl" => :recommended
  # root5 obviously conflicts, simply need `brew unlink root`
  conflicts_with "root"
  # cling also takes advantage
  needs :cxx11

  def config_opt(opt, pkg = opt)
    "-D#{opt}=#{(build.with? pkg) ? "ON" : "OFF"}"
  end

  def install
    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir["config/roots.in", "config/thisroot.*sh",
                  "etc/proof/utils/pq2/setup-pq2",
                  "man/man1/setup-pq2.1", "README/INSTALL", "README/README"],
      /bin.thisroot/, "libexec/thisroot"

    # ROOT does the following things by default that `brew audit` doesn't like:
    #  1. Installs libraries to lib/
    #  2. Installs documentation to man/
    # Homebrew expects:
    #  1. Libraries in lib/<some_folder>
    #  2. Documentation in share/man
    # so we set some flags to match what Homebrew expects
    args = %W[
      -Dgnuinstall=ON
      -DCMAKE_INSTALL_ELISPDIR=#{share}/emacs/site-lisp/#{name}
      -Dbuiltin_freetype=ON
      -Droofit=ON
      -Dminuit2=ON
      #{config_opt("python")}
      #{config_opt("ssl", "openssl")}
      #{config_opt("xrootd")}
      #{config_opt("mathmore", "gsl")}
      #{config_opt("fortran")}
      #{config_opt("fftw3", "fftw")}
    ]

    # ROOT forbids running CMake in the root of the source directory,
    # so run in a subdirectory (there's already one called `build`)
    mkdir "build_dir" do
      system "cmake", "..", *(std_cmake_args + args)
      system "make", "install"
    end

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For bash users:
      . $(brew --prefix root6)/libexec/thisroot.sh
    For zsh users:
      pushd $(brew --prefix root6) >/dev/null; . libexec/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source `brew --prefix root6`/libexec/thisroot.csh
    EOS
  end

  test do
    (testpath/"test.C").write <<-EOS.undent
      #include <iostream>
      void test() {
        std::cout << "Hello, world!" << std::endl;
      }
    EOS
    (testpath/"test.bash").write <<-EOS.undent
      . #{libexec}/thisroot.sh
      root -l -b -n -q test.C
    EOS
    assert_equal "\nProcessing test.C...\nHello, world!\n",
      `/bin/bash test.bash`
  end
end
