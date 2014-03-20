require 'formula'

class Repeatmasker < Formula
  homepage 'http://www.repeatmasker.org/'
  version '4.0.5'
  url 'http://www.repeatmasker.org/RepeatMasker-open-4-0-5.tar.gz'
  sha1 '9b00047639845bcff6dccf4148432ab2378d095c'

  option 'without-configure', 'Do not run configure'

  depends_on 'hmmer' # at least version 3.1 for nhmmer
  depends_on 'rmblast'
  depends_on 'trf'

  def install
    libexec.install Dir['*']
    bin.install_symlink '../libexec/RepeatMasker'

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

      /usr/bin/perl
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
    system "cd #{libexec} && ./configure <config.txt" if build.with? "configure"
  end

  def caveats; <<-EOS.undent
    Congratulations!  RepeatMasker is now ready to use.
    The program is installed with a minimal repeat library
    by default.  This library only contains simple, low-complexity,
    and common artefact ( contaminate ) sequences.  These are
    adequate for use with your own custom repeat library.  If you
    plan to search using common species specific repeats you will
    need to obtain the complete RepeatMasker repeat library from
    GIRI ( www.giriinst.org ) and install it in
    #{libexec}

    The default aligner is RMBlast. You may reconfigure RepeatMasker
    by running
      cd #{libexec} && ./configure
    EOS
  end

  test do
    system 'RepeatMasker'
  end
end
