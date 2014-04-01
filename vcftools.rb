require 'formula'

class Vcftools < Formula
  homepage 'http://vcftools.sourceforge.net/index.html'
  url 'https://downloads.sourceforge.net/project/vcftools/vcftools_0.1.12a.tar.gz'
  sha1 '66b982c67d2441f2b7fdbf2895f0749547852b13'
  version '0.1.12a-1' # detect new release, not an alpha version

  def install
    system "make", "install", "PREFIX=#{prefix}", "CPP=#{ENV.cxx}"
  end

  def caveats; <<-EOS.undent
    To use the Perl modules, make sure Vcf.pm, VcfStats.pm, and FaSlice.pm
    are included in your PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  def test
    system "#{bin}/vcftools"
  end
end
