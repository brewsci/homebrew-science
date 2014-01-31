require 'formula'

class Cegma < Formula
  homepage 'http://korflab.ucdavis.edu/datasets/cegma/'
  url 'http://korflab.ucdavis.edu/datasets/cegma/cegma_v2.4.010312.tar.gz'
  sha1 '4c046fe0376d69f6969a32af3481c60088306b9b'

  depends_on 'blast'
  depends_on 'geneid'
  depends_on 'genewise'
  depends_on 'hmmer'

  def install
    system 'make'
    mkdir_p libexec/'bin'
    system 'make', 'install', "INSTALLDIR=#{libexec/'bin'}"
    (lib/'perl5/site_perl').install Dir['lib/*.pm']
    libexec.install 'data'
    doc.install 'README'
    bin.install_symlink '../libexec/bin/cegma'
  end

  def caveats; <<-EOS.undent
    To use CEGMA, set the following environment variables:
      export CEGMA=#{HOMEBREW_PREFIX}/opt/cegma/libexec
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    system 'cegma --help 2>&1 |grep -q cegma'
  end
end
