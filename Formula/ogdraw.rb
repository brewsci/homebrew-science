class Ogdraw < Formula
  desc "OrganellarGenomeDRAW: convert GenBank files to graphical maps"
  homepage "http://ogdraw.mpimp-golm.mpg.de/"
  # doi "10.1007/s00294-007-0161-y", "10.1093/nar/gkt289"
  # tag "bioinformatics"

  url "http://ogdraw.mpimp-golm.mpg.de/resources/GeneMap-1.1.1.tar.gz"
  sha256 "d850aabd3c273e965ece148178a60ec9a097aad6cfa08c94a0e06a924fc9e063"

  bottle :disable, "Unsatisfied Perl dependencies"

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
    sha256 "709fe070fcabc02039a608a4ec71a188caa945f10660607ad6895f033cefb77f"
  end

  # drawgenemap: Add --gc option to add %GC graph
  patch do
    url "https://github.com/sjackman/OGDraw/commit/f650fdc23da46915e8d85f92dcc45cb35fad84d1.diff"
    sha256 "f2a2026185fbad270fa79c1f208d10f773925f6410668f573aabc755c1ec7945"
  end

  def install
    system "perl", "Makefile.PL", "PREFIX=#{prefix}"
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
