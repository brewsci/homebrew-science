class Root6 < Formula
  homepage "http://root.cern.ch"
  version "6.02.05"
  url "http://root.cern.ch/download/root_v#{version}.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v#{version}.source.tar.gz"
  sha1 "3cec8b763d8c1ddfd80b41983000359704f16e1e"
  head "http://root.cern.ch/git/root.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "144d63e630f1a67ca17212b0f0b0d39850f06744" => :yosemite
    sha1 "ed473955c3455a89eabb7ad45b00f9a82f16031f" => :mavericks
    sha1 "fa180069e6f975113bf50c6d9f5a7f09d4e156d9" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "xrootd" => :optional
  depends_on "openssl" => :optional
  depends_on :python => :recommended
  depends_on :x11 => :recommended if OS.linux?

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
