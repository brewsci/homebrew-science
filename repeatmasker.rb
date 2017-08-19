class Repeatmasker < Formula
  desc "Program that screens DNA sequences for interspersed repeats"
  homepage "http://www.repeatmasker.org/"
  # tag "bioinformatics"

  url "http://repeatmasker.org/RepeatMasker-open-4-0-7.tar.gz"
  version "4.0.7"
  sha256 "16faf40e5e2f521146f6692f09561ebef5f6a022feb17031f2ddb3e3aabcf166"
  revision 1

  bottle do
    sha256 "5f14080165dcb4ca8917a9e2045b3632df9226657815b09eb5877ba3160e7b87" => :sierra
    sha256 "876a2e019a4976d2845ff0ab8e2cf83ee2cec543129b29ded4d4ce6f36335c7a" => :el_capitan
    sha256 "b43b8c745ee09d88f7264947226c01ae4605cb453c0e8192bd1a6d36d351f040" => :yosemite
    sha256 "7e5f431a0b58b4bc663d20ebd7ba62b4dde52073acfaddb226d85fe3246b31fb" => :x86_64_linux
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
