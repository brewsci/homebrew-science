class Root < Formula
  desc "Root object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  version "5.34.34"
  sha256 "8c1faf893ed3b279f3500368b3dcd2087352020a69d3055c4d36726e7f6acd58"
  url "ftp://root.cern.ch/root/root_v#{version}.source.tar.gz"
  head "https://github.com/root-mirror/root.git", :branch => "v5-34-00-patches"

  bottle do
    sha256 "2e7d46e13046175804fa9045ba5b63ecb63d073f54e0568b27ef8eed3ac445e6" => :el_capitan
    sha256 "cccbfc6de1a4c6ba39265c97e94c057297e07f13f898539c1ffd6e07bc047414" => :yosemite
    sha256 "487019d87436f66c469c6e2e3533a7ec327c4e42bde4c7f8c376021a49e2cbce" => :mavericks
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
