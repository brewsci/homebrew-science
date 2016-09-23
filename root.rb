class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  version "5.34.36"
  url "https://root.cern.ch/download/root_v#{version}.source.tar.gz"
  sha256 "fc868e5f4905544c3f392cc9e895ef5571a08e48682e7fe173bd44c0ba0c7dcd"
  revision 1

  head "https://github.com/root-mirror/root.git", branch: "v5-34-00-patches"

  bottle do
    sha256 "cfdd163868a261c66e452996db76eede43245be4e575ca92f7803bdfd6ae8f39" => :el_capitan
    sha256 "28e9a5573e3e4268005a83d23641874f50b6f3afd27921ccd097ae0f33cb23a7" => :yosemite
    sha256 "f13fb325e42cb4c14955fca8f070f3119081078ed5fdb1dc33b2e5d170cddc4b" => :mavericks
  end

  option "with-qt", "Build with Qt graphics backend and GSI's Qt integration"

  depends_on "openssl"
  depends_on "xrootd" => :recommended
  depends_on "gsl" => :recommended
  depends_on "fftw" => :optional
  depends_on "qt" => [:optional, "with-qt3support"]
  depends_on x11: :optional
  depends_on :python if MacOS.version <= :snow_leopard

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
      --disable-ruby
      --prefix=#{prefix}
      --etcdir=#{prefix}/etc/root
      --mandir=#{man}
      --elispdir=#{share}/emacs/site-lisp/#{name}
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
