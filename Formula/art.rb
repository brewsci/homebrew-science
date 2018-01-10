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
    sha256 "8eddf3b61082268b5185a2464eaaca1f477a8e0bbce99913963f55bb2ee1466c" => :sierra
    sha256 "f28e7144ca35b359c2e6676fefb325ff4fb3af397b3961bcdfe4e957b0703b68" => :el_capitan
    sha256 "c1b5e9ce40fc8e30f39a0e37df2b7c15cabacfb12257bda0af41c53f92111cab" => :yosemite
    sha256 "be82f3dba925213a86c8d4dddb88459eb1da5f7a26477752121e407cbccf6448" => :x86_64_linux
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
