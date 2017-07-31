class GmapGsnap < Formula
  desc "Genomic Mapping & Alignment Program for RNA/EST/Short-read sequences"
  homepage "http://research-pub.gene.com/gmap/"
  url "http://research-pub.gene.com/gmap/src/gmap-gsnap-2017-01-14.tar.gz"
  sha256 "f3eca0b66ff9770c5965d43b3532e59d839e593de00fa3550141527f3c7f1d2c"
  # doi "10.1093/bioinformatics/btq057"
  # tag "bioinformatics"

  bottle do
    sha256 "8f3a579e7c037de3423b298be933ddcc33a88cfc2d81279b5e8eb942243cb2e6" => :sierra
    sha256 "6e4004bd20a29eb92ef7ca79a61de90a1a828a94390d0186d9f824c147066b66" => :el_capitan
    sha256 "45a1783741299e4ef20326f4d92e1847d036418316616e9f0401712a4d707dcf" => :yosemite
    sha256 "88934574226f97eb899872d7c7c766c1a42bfb5ede4f2432a40f0ea7cdfdbda2" => :x86_64_linux
  end

  depends_on "samtools"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
  end

  def caveats; <<-EOF.undent
    You will need to either download or build indexed search databases.
    See the readme file for how to do this:
      http://research-pub.gene.com/gmap/src/README

    Databases will be installed to:
      #{share}
    EOF
  end

  test do
    system "#{bin}/gsnap", "--version"
  end
end
