class Repeatmasker < Formula
  desc "Program that screens DNA sequences for interspersed repeats"
  homepage "http://www.repeatmasker.org/"
  # tag "bioinformatics"

  url "http://repeatmasker.org/RepeatMasker-open-4-0-7.tar.gz"
  version "4.0.7"
  sha256 "16faf40e5e2f521146f6692f09561ebef5f6a022feb17031f2ddb3e3aabcf166"
  revision 1

  bottle do
    sha256 "d23f2a802c70a9413bde01c90020b8cf988df9ccdf1d77ad029a3a3edbb1e4b1" => :sierra
    sha256 "97c07a4d6450433a72b3173d1d70648151e8a11e5c31fda45a3f6dcfff5d825b" => :el_capitan
    sha256 "f0eab468716f826cfca27ecab52211a4f09677c5d263d72afcc51ee52d6769f1" => :yosemite
    sha256 "91fba4834f5bd811de3085d963cc63ef3eb5038791ce4cf2ae5078a888345652" => :x86_64_linux
  end

  option "without-configure", "Do not run configure"

  depends_on "hmmer" # at least version 3.1 for nhmmer
  depends_on "perl" => :optional
  depends_on "rmblast"
  depends_on "trf"

  def install
    perl = if build.with? "perl"
      Formula["perl"].opt_bin/"perl"
    else
      "/usr/bin/perl"
    end

    libexec.install Dir["*"]
    bin.install_symlink "../libexec/RepeatMasker"

    # Configure RepeatMasker. The prompts are:
    # PRESS ENTER TO CONTINUE
    # Enter path [ perl ]:
    # REPEATMASKER INSTALLATION DIRECTORY Enter path
    # TRF PROGRAM Enter path
    # 2. RMBlast - NCBI Blast with RepeatMasker extensions: [ Un-configured ]
    # RMBlast (rmblastn) INSTALLATION PATH
    # Do you want RMBlast to be your default search engine for Repeatmasker?
    # 4. HMMER3.1 & DFAM
    # HMMER INSTALLATION PATH Enter path
    # Do you want HMMER to be your default search engine for Repeatmasker?
    # 5. Done
    (libexec/"config.txt").write <<-EOS.undent

      #{perl}
      #{libexec}
      #{HOMEBREW_PREFIX}/bin/trf
      2
      #{HOMEBREW_PREFIX}/bin
      Y
      4
      #{HOMEBREW_PREFIX}/bin
      N
      5
      EOS
    if build.with? "configure"
      Dir.chdir libexec.to_s do
        system "./configure <config.txt"
      end
    end
  end

  def caveats; <<-EOS.undent
    Congratulations!  RepeatMasker is now ready to use.
    The program is installed with a minimal repeat library
    by default.  This library only contains simple, low-complexity,
    and common artefact ( contaminate ) sequences.  These are
    adequate for use with your own custom repeat library.  If you
    plan to search using common species specific repeats you will
    need to obtain the complete RepeatMasker repeat library from
    GIRI ( www.girinst.org ) and install it:
      cd #{libexec}
      tar zxvf repeatmaskerlibraries-20140131.tar.gz
      ./configure <config.txt

    The default aligner is RMBlast. You may reconfigure RepeatMasker
    by running
      cd #{libexec} && ./configure
    EOS
  end

  test do
    system "#{bin}/RepeatMasker"
  end
end
