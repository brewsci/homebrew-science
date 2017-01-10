class Art < Formula
  desc "Simulation tools to generate synthetic NGS reads"
  homepage "http://www.niehs.nih.gov/research/resources/software/biostatistics/art/index.cfm"
  # doi "10.1093/bioinformatics/btr708"
  # tag "bioinformatics"

  if OS.mac?
    url "https://www.niehs.nih.gov/research/resources/assets/docs/artsrcmountrainier20160605macostgz.tgz"
    version "20160605"
    sha256 "1c467c374ec17b1c2c815f4c24746bece878876faaf659c2541f280fe7ba85f7"
  else
    url "https://www.niehs.nih.gov/research/resources/assets/docs/artsrcmountrainier20160605linuxtgz.tgz"
    version "20160605"
    sha256 "69aede60884eb848de043aae5294274b7ca6348b7384a8380f0ac5a4dfeff488"
  end

  bottle do
    cellar :any
    sha256 "c811bc3baceb7c217d1096f094d97cb91a0797880897a0edaaebadd0feadfa94" => :el_capitan
    sha256 "031f2d36aeda67a3207950bd4461435df42a8e33c6e82434e45038d787b0b912" => :yosemite
    sha256 "22f4e0e4911921a44553ce9c1eb7e540c2eee411fb8bf65e2a6a01eb3654b6fb" => :mavericks
    sha256 "d41660010aa415f7edfcccd22ca8df4d7cc3e671d6b037f00706109a227ed2b0" => :x86_64_linux
  end

  depends_on "gsl"

  def install
    ENV.append "CPPFLAGS", "-I#{Formula["gsl"].opt_include}"
    ENV.append "LDFLAGS",  "-L#{Formula["gsl"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # remove the bundled binaries so they get re-made against our libraries
    system "make", "clean"
    system "make", "install"
    doc.install %w[AUTHORS COPYING ChangeLog NEWS README art_454_README art_SOLiD_README art_illumina_README]
    pkgshare.install %w[examples 454_profiles Illumina_profiles SOLiD_profiles]
  end

  test do
    system "#{bin}/art_illumina | grep 'MiSeq'"
    system "#{bin}/art_SOLiD | grep 'F3-F5'"
    system "#{bin}/art_454 | grep 'FLX'"
  end
end
