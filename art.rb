class Art < Formula
  desc "Simulation tools to generate synthetic NGS reads"
  homepage "http://www.niehs.nih.gov/research/resources/software/biostatistics/art/index.cfm"
  # doi "10.1093/bioinformatics/btr708"
  # tag "bioinformatics"

  if OS.mac?
    url "http://www.niehs.nih.gov/research/resources/assets/docs/artsrcchocolatecherrycake031915macostgz.tgz"
    version "031915"
    sha256 "35cb37d3d5ce428fed77b59e4aa5b1498572c1fe9ed140173db02e6b1767c5f8"
  else
    url "http://www.niehs.nih.gov/research/resources/assets/docs/artsrcchocolatecherrycake031915linuxtgz.tgz"
    version "031915"
    sha256 "306f1dd9f207e59e5fc07b2c1152fa091b142dc65267f7b37538931b60584965"
  end
  revision 1

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
