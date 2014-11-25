require "formula"

class Root < Formula
  homepage "http://root.cern.ch"
  version "5.34.23"
  sha1 "50892105b84b9c2c3ee1cbb7b0cca2bde29453e6"
  url "ftp://root.cern.ch/root/root_v#{version}.source.tar.gz"
  mirror "http://ftp.riken.jp/pub/ROOT/root_v#{version}.source.tar.gz"
  head "https://github.com/root-mirror/root.git", :branch => "v5-34-00-patches"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "7e86a20f898832a7eaf19e9f012854cce1f7eb90" => :yosemite
    sha1 "6b7c8b53442d8277afcb64cda63e84d2e704007c" => :mavericks
    sha1 "d68af89320af63ced42908b68a6357ae8acaa71a" => :mountain_lion
  end

  option "with-qt", "Build with Qt graphics backend and GSI's Qt integration"

  depends_on "openssl"
  depends_on "xrootd" => :recommended
  depends_on "fftw" => :optional
  depends_on "qt" => [:optional, "with-qt3support"]
  depends_on :x11 => :optional
  depends_on :python

  def install
    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir["config/roots.in", "config/thisroot.*sh",
                  "etc/proof/utils/pq2/setup-pq2",
                  "man/man1/setup-pq2.1", "README/INSTALL", "README/README"],
      /bin.thisroot/, "libexec/thisroot"

    # Determine architecture
    arch = MacOS.prefer_64_bit? ? "macosx64" : "macosx"

    # N.B. that it is absolutely essential to specify
    # the --etcdir flag to the configure script.  This is
    # due to a long-known issue with ROOT where it will
    # not display any graphical components if the directory
    # is not specified:
    # http://root.cern.ch/phpBB3/viewtopic.php?f=3&t=15072
    args = %W[
      #{arch}
      --all
      --enable-builtin-glew
      --enable-builtin-freetype
      --prefix=#{prefix}
      --etcdir=#{prefix}/etc/root
      --mandir=#{man}
    ]

    if build.with? "x11"
      args << "--disable-cocoa"
      args << "--enable-x11"
    end

    if build.with? "qt"
      args << "--enable-qt"
      args << "--enable-qtgsi"
      # ROOT configure script does not search for Qt framework
      inreplace "config/Makefile.config" do |s|
        s.gsub! /^QTLIBDIR .*/, "QTLIBDIR := -F #{Formula["qt"].opt_lib}"
        s.gsub! /^QTLIB .*/, "QTLIB := -framework QtCore -framework QtGui -framework Qt3Support"
      end
    end

    system "./configure", *args

    system "make"
    system "make", "install"

    # needed to run test suite
    prefix.install "test"

    libexec.mkpath
    mv Dir["#{bin}/*.*sh"], libexec
  end

  test do
    system "make", "-C", "#{prefix}/test/", "hsimple"
    system "#{prefix}/test/hsimple"
  end

  def caveats; <<-EOS.undent
    Because ROOT depends on several installation-dependent
    environment variables to function properly, you should
    add the following commands to your shell initialization
    script (.bashrc/.profile/etc.), or call them directly
    before using ROOT.

    For csh/tcsh users:
      source `brew --prefix root`/libexec/thisroot.csh
    For bash/zsh users:
      . $(brew --prefix root)/libexec/thisroot.sh
    EOS
  end
end
