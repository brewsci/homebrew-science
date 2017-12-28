class ClustalOmega < Formula
  homepage "http://www.clustal.org/omega/"
  # doi "10.1038/msb.2011.75"
  # tag "bioinformatics"

  url "http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz"
  sha256 "8683d2286d663a46412c12a0c789e755e7fd77088fb3bc0342bb71667f05a3ee"

  bottle do
    cellar :any
    sha256 "caa2e452212b280d512d50ac0e93156df3d260d5814f4552ece2a871e60f3712" => :high_sierra
    sha256 "d03a460a77f2de1cf2253a95a21fc7662945ca0763f7ef917664040a90863bbe" => :sierra
    sha256 "5ed21f129ca5071628176a38aa9051b72e71d8e641bbd76006c340622c0ccc9b" => :el_capitan
    sha256 "fa1743ef79747a69190251c0fbfa7d259cf683794a49d2f989a0e9ac2fa937a7" => :x86_64_linux
  end

  depends_on "argtable"

  def install
    system "./configure", "--prefix=#{prefix}",
      "--disable-debug", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/clustalo", "--version"
  end
end
