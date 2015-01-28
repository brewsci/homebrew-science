require "formula"

class Root < Formula
  homepage "http://root.cern.ch"
  version "5.34.25"
  sha1 "dccd5b10c136c53f2ef94a7503b569daba6422f8"
  url "ftp://root.cern.ch/root/root_v#{version}.source.tar.gz"
  mirror "http://ftp.riken.jp/pub/ROOT/root_v#{version}.source.tar.gz"
  head "https://github.com/root-mirror/root.git", :branch => "v5-34-00-patches"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    revision 2
    sha1 "6f4d211fb0d98d7c40df8737251ca110432b4274" => :yosemite
    sha1 "b3e05b2ecf4b3905c6239fff7733a2e7c81fa24d" => :mavericks
    sha1 "5587405366e3dc3c40e3c4d86ffef4d95134961c" => :mountain_lion
  end

  # Fixes compilation with recent xrootd; see:
  # https://sft.its.cern.ch/jira/browse/ROOT-6998?
  patch do
    url "https://sft.its.cern.ch/jira/secure/attachment/17857/0001-TNetXNGFile-explicitly-include-XrdVersion.hh.patch"
    sha1 "ded7da0a65ccd481dfd5639f7dcd899afeb2244f"
  end

  option "with-qt", "Build with Qt graphics backend and GSI's Qt integration"

  depends_on "openssl"
  depends_on "xrootd" => :recommended
  depends_on "gsl" => :recommended
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

    # N.B. that it is absolutely essential to specify
    # the --etcdir flag to the configure script.  This is
    # due to a long-known issue with ROOT where it will
    # not display any graphical components if the directory
    # is not specified:
    # http://root.cern.ch/phpBB3/viewtopic.php?f=3&t=15072
    args = %W[
      --all
      --enable-builtin-glew
      --enable-builtin-freetype
      --prefix=#{prefix}
      --etcdir=#{prefix}/etc/root
      --mandir=#{man}
    ]

    args << "--enable-mathmore" if build.with? "gsl"

    if build.with? "x11"
      args << "--disable-cocoa"
      args << "--enable-x11"
    end

    if build.with? "qt"
      args << "--enable-qt"
      args << "--enable-qtgsi"
      args << "--with-qt-libdir=#{Formula["qt"].opt_lib}"
      args << "--with-qt-incdir=#{Formula["qt"].opt_include}"
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

    For bash users:
      . $(brew --prefix root)/libexec/thisroot.sh
    For zsh users:
      pushd $(brew --prefix root) >/dev/null; . libexec/thisroot.sh; popd >/dev/null
    For csh/tcsh users:
      source `brew --prefix root`/libexec/thisroot.csh
    EOS
  end
end
