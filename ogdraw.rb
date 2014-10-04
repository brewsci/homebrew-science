require 'formula'

# OrganellarGenomeDRAW
class Ogdraw < Formula
  homepage 'http://ogdraw.mpimp-golm.mpg.de/'
  #doi "10.1007/s00294-007-0161-y" => "2007", "10.1093/nar/gkt289" => "2013"
  #tag "bioinformatics"
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

  # drawgenemap: Add --irscan and --ircoord options
  patch do
    url "https://github.com/sjackman/OGDraw/commit/ac56bd6c871635588db1911b1f962929e2f13b88.diff"
    sha1 "4d5d3287cbe35f1a30ef7ba966ab393a3ec0e2cc"
  end

  # drawgenemap: Add --gc option to add %GC graph
  patch do
    url "https://github.com/sjackman/OGDraw/commit/f650fdc23da46915e8d85f92dcc45cb35fad84d1.diff"
    sha1 "d5c5af80b5ee21dada43fc02908d91dfa3305e5d"
  end

  def install
    system *%W[perl Makefile.PL PREFIX=#{prefix}]
    system "make", "pure_install"
    bin.install "irscan/bin/irscan_linux_x86" => "irscan" if OS.linux?
  end

  def caveats; <<-EOS.undent
    Set the PERL5LIB environment variable:
      export PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl:${PERL5LIB}
    EOS
  end

  test do
    system "PERL5LIB=#{HOMEBREW_PREFIX}/lib/perl5/site_perl #{bin}/drawgenemap"
  end
end
