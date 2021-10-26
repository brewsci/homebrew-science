class Ogdraw < Formula
  desc "OrganellarGenomeDRAW: convert GenBank files to graphical maps"
  homepage "http://ogdraw.mpimp-golm.mpg.de/"
  # doi "10.1007/s00294-007-0161-y", "10.1093/nar/gkt289"
  # tag "bioinformatics"

  url "http://ogdraw.mpimp-golm.mpg.de/resources/GeneMap-1.1.1.tar.gz"
  sha256 "d850aabd3c273e965ece148178a60ec9a097aad6cfa08c94a0e06a924fc9e063"

  depends_on "imagemagick"

  # Depends_on "Bio::Perl" => :perl
  # Depends_on "Bio::Restriction::Analysis" => :perl
  # Depends_on "Bio::Root::Root" => :perl
  # Depends_on "Bio::SeqFeature::Generic" => :perl
  # Depends_on "Bio::SeqIO" => :perl
  # Depends_on "Image::Magick" => :perl
  # Depends_on "PostScript::Simple" => :perl
  # Depends_on "XML::Generator" => :perl

  # drawgenemap: Add --irscan and --ircoord options
  patch do
    url "https://github.com/sjackman/OGDraw/commit/ac56bd6c871635588db1911b1f962929e2f13b88.patch?full_index=1"
    sha256 "5c0482d5e918fd45857745b257b0965d7170e3628025056077a859f2eb2e08f2"
  end

  # drawgenemap: Add --gc option to add %GC graph
  patch do
    url "https://github.com/sjackman/OGDraw/commit/f650fdc23da46915e8d85f92dcc45cb35fad84d1.patch?full_index=1"
    sha256 "63a93e3517ea6187ca6d880bcf1350e782d60f5ed8c5bcd5bfeb0f41db4537b6"
  end

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
    system "make", "pure_install"
    bin.install "irscan/bin/irscan_linux_x86" => "irscan" if OS.linux?

    libexec.install bin/"drawgenemap"
    (bin/"drawgenemap").write_env_script libexec/"drawgenemap",
      PERL5LIB: lib/"perl5/site_perl:$PERL5LIB"
  end

  test do
    system "#{bin}/drawgenemap"
  end
end
