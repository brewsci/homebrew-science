class Root6 < Formula
  # in order to update, simply change version number and update sha256
  version_number = "6.04.08"
  desc "Object oriented framework for large scale data analysis"
  homepage "http://root.cern.ch"
  url "https://root.cern.ch/download/root_v#{version_number}.source.tar.gz"
  mirror "https://fossies.org/linux/misc/root_v#{version_number}.source.tar.gz"
  version version_number
  sha256 "794c22960131959d2ae904176b8e44393f05e45bef79a1fed6f15f007b98fc61"
  head "http://root.cern.ch/git/root.git"

  bottle do
    sha256 "4d43c083bd890755a6a9c53ce71b679a1537b4900f6f1a270c480d0b9f6d47b1" => :el_capitan
    sha256 "5d90f8f4eb7191a75a842b4b5734a4f71bbff0a17868b354d8b221ee92f62533" => :yosemite
    sha256 "74c602d5829375ea0a2eb93e91461accd208d23fb0696bb40ae410e27984f3f6" => :mavericks
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
