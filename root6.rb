class Root6 < Formula
  # in order to update, simply change version number and update sha256
  version_number = "6.04.02"
  desc "Object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  url "http://root.cern.ch/download/root_v#{version_number}.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v#{version_number}.source.tar.gz"
  version version_number
  sha256 "81415e37a5592ef565969db84a8390611b298ed1ceda5a36f939f6422fed399a"
  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "0fc5a540a16fb977085a2925d12c368e96dc58c2d3c1642d33d6a72ca149c5c6" => :el_capitan
    sha256 "48751a66162a8195a8cc3b8112da5023cc7addccfdb26a4b29457f5c161f2ee7" => :yosemite
    sha256 "3ba88d32f9d7eff05c065834d800fb7dcc557437970b5ac3d1d5a7cf27513885" => :mavericks
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
