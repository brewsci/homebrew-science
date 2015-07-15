class Root6 < Formula
  desc "An object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  version "6.04.00"
  url "http://root.cern.ch/download/root_v#{version}.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v#{version}.source.tar.gz"
  sha256 "c5fa1e5706f2f5f4e134c78926ed9cfcfe543aff3d39c41762911668a9eebeea"
  head "http://root.cern.ch/git/root.git"

  bottle do
    revision 1
    sha256 "c5141ef686d0538128fe2d8f426177a6567b3aa122604c094b11044a6567962e" => :yosemite
    sha256 "094df33fc9e3baa291633a6011e214691e52032ca29f06f3d03ad7f47cd7b245" => :mavericks
    sha256 "9b7dd452d68b5f2182212777393bf9ca0362fb70dd4f6774efc51e784fcaab8b" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "xrootd" => :optional
  depends_on "openssl" => :optional
  depends_on :python => :recommended
  depends_on :x11 => :recommended if OS.linux?

  conflicts_with "root"

  needs :cxx11

  def cmake_opt(opt, pkg = opt)
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

    # Prevent collision with brewed freetype
    inreplace "graf2d/freetype/CMakeLists.txt", /install\(/, "#install("
    # xrootd: Workaround for
    # TXNetFile.cxx:64:10: fatal error: 'XpdSysPthread.h' file not found
    # this seems to be related to homebrew superenv
    inreplace "net/netx/CMakeLists.txt",
      /include_directories\(/, "\\0${CMAKE_SOURCE_DIR}/proof/proofd/inc "

    mkdir "cmake-build" do
      system "cmake", "..", "-Dgnuinstall=ON", "-Dbuiltin_freetype=ON",
        "-Droofit=ON",  # build with RooFit
        "-Dminuit2=ON", # build with Minuit2
        cmake_opt("python"),
        cmake_opt("ssl", "openssl"),
        cmake_opt("xrootd"),
        *std_cmake_args
      system "make", "install"
    end

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
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
end
