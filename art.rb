class Art < Formula
  desc "Simulation tools to generate synthetic NGS reads"
  homepage "https://www.niehs.nih.gov/research/resources/software/biostatistics/art/index.cfm"
  revision 1
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
    sha256 "38e9e077cab399c9b56dda31668c6eed063207347c55cc20504286ffcc2121bd" => :sierra
    sha256 "e4818f12e81c80ad7bd3d7a4a6671395114c86527ca319d7fbe7e12a11cd19f0" => :el_capitan
    sha256 "4e2f32136949eb196314f3652d62ac274ae3a77c4d6e41b4a3c87ab46b8e284a" => :yosemite
    sha256 "b0f77270607223e18380323f2cf32cdba80373431df203b7dc8dd7189bbaee61" => :x86_64_linux
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
