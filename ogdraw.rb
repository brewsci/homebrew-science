class Ogdraw < Formula
  desc "OrganellarGenomeDRAW: convert GenBank files to graphical maps"
  homepage "http://ogdraw.mpimp-golm.mpg.de/"
  # doi "10.1007/s00294-007-0161-y", "10.1093/nar/gkt289"
  # tag "bioinformatics"

  url "http://ogdraw.mpimp-golm.mpg.de/resources/GeneMap-1.1.1.tar.gz"
  sha256 "d850aabd3c273e965ece148178a60ec9a097aad6cfa08c94a0e06a924fc9e063"

  depends_on "imagemagick"

  depends_on "Bio::Perl" => :perl
  depends_on "Bio::Restriction::Analysis" => :perl
  depends_on "Bio::Root::Root" => :perl
  depends_on "Bio::SeqFeature::Generic" => :perl
  depends_on "Bio::SeqIO" => :perl
  depends_on "Image::Magick" => :perl
  depends_on "PostScript::Simple" => :perl
  depends_on "XML::Generator" => :perl

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

    libexec.install bin/"drawgenemap"
    (bin/"drawgenemap").write_env_script libexec/"drawgenemap",
      :PERL5LIB => lib/"perl5/site_perl:$PERL5LIB"
  end

  test do
    system "#{bin}/drawgenemap"
  end
end
