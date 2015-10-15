class Root6 < Formula
  # in order to update, simply change version number and update sha256
  version_number = "6.04.04"
  desc "Object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  url "http://root.cern.ch/download/root_v#{version_number}.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v#{version_number}.source.tar.gz"
  version version_number
  sha256 "65620a7c15c6575794ee58749e409f8562d5a64e58443cfc2d55f5eb962a0562"
  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "4cd8b7af0a6d4a7f6884a15e2468f89c3c86d2b02368103947f5832ef305cfb9" => :el_capitan
    sha256 "abfc294f662a6e854a450176369c38b1500205133c25f28770f9df83a75aa172" => :yosemite
    sha256 "4530e026ba8b0b7979beb6bebdfac3fc8c90ab731cfb0ac74767e4cf845047f3" => :mavericks
  end

  depends_on "xrootd" => :optional
  depends_on "openssl" => :recommended # use homebrew's openssl
  depends_on :python => :recommended # make sure we install pyroot
  depends_on :x11 => :recommended if OS.linux?
  # root5 obviously conflicts, simply need `brew unlink root`
  conflicts_with "root"
  # cling also takes advantage
  needs :cxx11

  def config_opt(opt, pkg = opt)
    "--#{(build.with? pkg) ? "enable" : "disable"}-#{opt}"
  end

  def install
    # brew audit doesn't like non-executables in bin
    # so we will move {thisroot,setxrd}.{c,}sh to libexec
    # (and change any references to them)
    inreplace Dir["config/roots.in", "config/thisroot.*sh",
                  "etc/proof/utils/pq2/setup-pq2",
                  "man/man1/setup-pq2.1", "README/INSTALL", "README/README"],
      /bin.thisroot/, "libexec/thisroot"

    args = %W[
      --prefix=#{prefix}
      --elispdir=#{share}/emacs/site-lisp/#{name}
      --enable-builtin-freetype
      --enable-roofit
      --enable-minuit2
      #{config_opt("python")}
      #{config_opt("ssl", "openssl")}
      #{config_opt("xrootd")}
    ]

    system "./configure", "--help"
    system "./configure", *args
    system "make"
    system "make", "install"

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
