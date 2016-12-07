class Root < Formula
  desc "Object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  version "5.34.36"
  revision 2
  head "https://github.com/root-mirror/root.git", :branch => "v5-34-00-patches"

  stable do
     url "https://root.cern.ch/download/root_v5.34.36.source.tar.gz"
     sha256 "fc868e5f4905544c3f392cc9e895ef5571a08e48682e7fe173bd44c0ba0c7dcd"

     if MacOS.version == :sierra
       # Same as https://root.cern.ch/gitweb/?p=root.git;a=patch;h=b86b8376e0c49d45cd909619bbf058d45398b9a9
       # but with the change to LICENSE.txt removed to prevent it from failing
       # Only needed so patch below can apply successfully
       patch do
         url "https://gist.githubusercontent.com/ilovezfs/df76b33d0e4da8243508d44e8ce9eda9/raw/fd149d6dafcae4aae5dbbc86e7ea2bef7430274f/gistfile1.txt"
         sha256 "4214bc69f46c97f4e2d545c3942d8ec158105e4059f25f7f2323671377603e3f"
       end

       # Patch for macOS Sierra; remove for > 5.34.36
       # Already fixed in the v5-34-00-patches branch
       patch do
         url "https://root.cern.ch/gitweb/?p=root.git;a=patch;h=c06fdeae0b3b4d627aacef2bda9df0acd079626b"
         sha256 "90b8cbf99d6c1d6f04e0ad1ee0c1afeefa798b67151be63008f0573b5ed8d0f3"
       end
     end
   end

  bottle do
    sha256 "1d68a7c81296880e4a9bd8ab98e4e069e6220b422b004dc035f4543e8eb5b857" => :sierra
    sha256 "fac65200906f92419295887a51bc63729a6a0bc16ce6a814f9d63c6447c7cc53" => :el_capitan
    sha256 "6ba709de6f4f67a406ba8ebceb07830213de2538dda936e2e262a1daa72de350" => :yosemite
  end

  depends_on "openssl"
  depends_on "xrootd" => :recommended
  depends_on "gsl" => :recommended
  depends_on "fftw" => :optional
  depends_on :x11 => :optional
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
