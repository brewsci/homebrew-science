require 'formula'

class Repeatmasker < Formula
  homepage 'http://www.repeatmasker.org/'
  #tag "bioinformatics"

  version '4.0.5'
  url 'http://www.repeatmasker.org/RepeatMasker-open-4-0-5.tar.gz'
  sha1 '9b00047639845bcff6dccf4148432ab2378d095c'

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    sha1 "c46730ceac418dfa4ed61989c944ca64ab224433" => :yosemite
    sha1 "f037a6b32368ed09cdfc2e639d302dd5828064af" => :mavericks
    sha1 "ad7aefdfd3b9393cdb12974647b52575a76f65da" => :mountain_lion
  end

  option 'without-configure', 'Do not run configure'

  depends_on 'hmmer' # at least version 3.1 for nhmmer
  depends_on "perl" => :optional
  depends_on 'rmblast'
  depends_on 'trf'

  def install
    perl = if build.with? "perl"
      Formula["perl"].opt_bin/"perl"
    else
      "/usr/bin/perl"
    end

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
    GIRI ( www.giriinst.org ) and install it:
      cd #{libexec}
      tar zxvf repeatmaskerlibraries-20140131.tar.gz
      ./configure <config.txt

    The default aligner is RMBlast. You may reconfigure RepeatMasker
    by running
      cd #{libexec} && ./configure
    EOS
  end

  test do
    system 'RepeatMasker'
  end
end
