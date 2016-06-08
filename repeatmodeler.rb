class Repeatmodeler < Formula
  desc "De-novo repeat family identification and modeling package"
  homepage "http://www.repeatmasker.org/RepeatModeler.html"
  # tag "bioinformatics"

  url "http://www.repeatmasker.org/RepeatModeler-open-1-0-8.tar.gz"
  version "1.0.8"
  sha256 "3ac87af3fd3da0c9a2ca8e7b8885496abdf3383e413575548c1d234c15f27ecc"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "d3856db1196dd29a84120ac14461d64c5c3a9d10432830dcb6be94ecd2478ba1" => :el_capitan
    sha256 "e3be3d6078936510c6b79ed62c155ac876e61f7de9d5ed6ac1409ecbbc562f19" => :yosemite
    sha256 "ef4c93df7fbcca97851ad7e3de571c0c6a1b94843384eaea32a53c27cfde11ab" => :mavericks
    sha256 "0495628e44f390035e2b0ad596016e156e22b2be448cae26fdca317bdad88cc5" => :x86_64_linux
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
    assert_match version.to_s, shell_output("/usr/bin/perl #{bin}/RepeatModeler -v")
  end
end
