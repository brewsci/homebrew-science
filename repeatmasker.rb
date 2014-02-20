require 'formula'

class Repeatmasker < Formula
  homepage 'http://www.repeatmasker.org/'
  version '4.0.5'
  url 'http://www.repeatmasker.org/RepeatMasker-open-4-0-5.tar.gz'
  sha1 '9b00047639845bcff6dccf4148432ab2378d095c'

  option 'without-configure', 'Do not run configure'

  depends_on 'hmmer' # at least version 3.1 for nhmmer
  depends_on 'trf'

  def install
    libexec.install Dir['*']
    bin.install_symlink '../libexec/RepeatMasker'

    # Configure RepeatMasker. The prompts are:
    # PRESS ENTER TO CONTINUE
    # Enter path [ perl ]:
    # REPEATMASKER INSTALLATION DIRECTORY Enter path
    # TRF PROGRAM Enter path
    # 4. HMMER3.1 & DFAM
    # HMMER INSTALLATION PATH Enter path
    # Do you want HMMER to be your default search engine for Repeatmasker?
    # 5. Done
    cd libexec do
      open('config.txt', 'w') do |file|
        file.write <<-EOS.undent

          /usr/bin/perl
          #{libexec}
          #{HOMEBREW_PREFIX}/bin/trf
          4
          #{HOMEBREW_PREFIX}/bin
          Y
          5
          EOS
      end
      system './configure <config.txt' if build.with? 'configure'
    end
  end

  def caveats; <<-EOS.undent
    You may reconfigure RepeatMasker by running
      cd #{libexec} && ./configure
    EOS
  end

  test do
    system 'RepeatMasker'
  end
end
