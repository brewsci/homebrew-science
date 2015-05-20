class Repeatmodeler < Formula
  homepage "http://www.repeatmasker.org/RepeatModeler.html"
  # tag "bioinformatics"

  version "1.0.8"
  url "http://www.repeatmasker.org/RepeatModeler-open-1-0-8.tar.gz"
  sha256 "3ac87af3fd3da0c9a2ca8e7b8885496abdf3383e413575548c1d234c15f27ecc"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "a9554c56b1727320b1b5048ff89884941af6ee6a64a2afc7f3c621172264d522" => :yosemite
    sha256 "fce72ab593a100187d325b9789387e39e91dc3779de763556fb6aa516b1aaf18" => :mavericks
    sha256 "c2088c839d630afdc8e89a44f48ad3912cc86cb5ff52b041e58c7b4328cface8" => :mountain_lion
  end

  option "without-configure", "Do not run configure"

  depends_on "recon"
  depends_on "repeatmasker"
  depends_on "repeatscout"
  depends_on "rmblast"
  depends_on "trf"

  # Configure RepeatModeler. The prompts are:
  # PRESS ENTER TO CONTINUE
  # PERL INSTALLATION PATH
  # REPEATMODELER INSTALLATION PATH
  # REPEATMASKER INSTALLATION PATH
  # RECON INSTALLATION PATH
  # RepeatScout INSTALLATION PATH
  # 1. RMBlast - NCBI Blast with RepeatMasker extensionst
  # RMBlast (rmblastn) INSTALLATION PATH
  # Do you want RMBlast to be your default search engine for Repeatmasker?
  # 3. Done
  def install
    prefix.install Dir["*"]
    bin.install_symlink %w[../BuildDatabase ../RepeatModeler]

    (prefix/"config.txt").write <<-EOS.undent

      /usr/bin/perl
      #{prefix}
      #{Formula["repeatmasker"].opt_prefix/"libexec"}
      #{Formula["recon"].opt_prefix/"bin"}
      #{Formula["repeatscout"].opt_prefix}
      #{Formula["trf"].opt_prefix/"bin"}
      1
      #{HOMEBREW_PREFIX}/bin
      Y
      3
      EOS
  end

  def post_install
    cd prefix do
      system "perl ./configure <config.txt"
    end if build.with? "configure"
  end

  def caveats; <<-EOS.undent
    To reconfigure RepeatModeler, run
      brew postinstall repeatmodeler
    or
      cd #{prefix} && perl ./configure <config.txt
    EOS
  end

  test do
    system "#{bin}/RepeatModeler"
  end
end
