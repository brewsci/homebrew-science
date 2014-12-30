class Repeatmodeler < Formula
  homepage "http://www.repeatmasker.org/RepeatModeler.html"
  #tag "bioinformatics"

  version "1.0.7"
  url "http://www.repeatmasker.org/RepeatModeler-open-1-0-7.tar.gz"
  sha1 "01e07eedd051c32285dc650da7643f5aecaf490c"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "3d516316eb1f2292eb69f04c431dfe9a8fea166f" => :yosemite
    sha1 "a2ca0624ac59dc50db38a798ea196438646ecf7c" => :mavericks
    sha1 "7b4cb9aa5e075aa33e5aba832547947449bc60e6" => :mountain_lion
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
    cd prefix do
      system "perl ./configure <config.txt"
    end if build.with? "configure"
  end

  def caveats; <<-EOS.undent
    To reconfigure RepeatModeler, run
      cd #{prefix} && perl ./configure
    EOS
  end

  test do
    system "#{bin}/RepeatModeler"
  end
end
