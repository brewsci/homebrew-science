require 'formula'

# OrganellarGenomeDRAW
class Ogdraw < Formula
  homepage 'http://ogdraw.mpimp-golm.mpg.de/'
  url 'http://ogdraw.mpimp-golm.mpg.de/resources/GeneMap-1.1.1.tar.gz'
  sha1 '16ea480aa13d702cc30a7160b8a3668c51627989'

  depends_on 'imagemagick'

  depends_on 'Bio::Perl' => :perl
  depends_on 'Bio::Restriction::Analysis' => :perl
  depends_on 'Bio::Root::Root' => :perl
  depends_on 'Bio::SeqFeature::Generic' => :perl
  depends_on 'Bio::SeqIO' => :perl
  depends_on 'Image::Magick' => :perl
  depends_on 'PostScript::Simple' => :perl
  depends_on 'XML::Generator' => :perl

  def install
    system *%W[perl Makefile.PL PREFIX=#{prefix}]
    system *%w[make install]
  end

  def caveats; <<-EOS.undent
    Set the PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    system 'drawgenemap'
  end
end
