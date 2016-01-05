class Root6 < Formula
  # in order to update, simply change version number and update sha256
  version_number = "6.06.00"
  desc "Object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  url "https://root.cern.ch/download/root_v#{version_number}.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v#{version_number}.source.tar.gz"
  version version_number
  sha256 "96e460883a3a0f350beda732364b8091b2bd98e1e953e0d86a51eeba19a0edcb"
  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "99bd90944a2e8a9f058bf8abf04adc420c27cbac151d62091685ba927702c74f" => :el_capitan
    sha256 "b6ea9756b192d8ac8145a06e8384329cdb62c6e6513661bc666ba57e074b87f8" => :yosemite
    sha256 "ba852841770718811dbe84305975105338cce4c8d68d860cecaa5ef64dfac92b" => :mavericks
  end

  depends_on "xrootd" => :optional
  depends_on "openssl" => :recommended # use homebrew's openssl
  depends_on :python => :recommended # make sure we install pyroot
  depends_on :x11 => :recommended if OS.linux?
  depends_on "gsl" => :recommended
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
      #{config_opt("mathmore", "gsl")}
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
