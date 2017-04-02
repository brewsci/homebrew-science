class Nxtrim < Formula
  desc "Trim adapters for Illumina Nextera Mate Pair libraries"
  homepage "https://github.com/sequencing/NxTrim"
  # doi "10.1101/007666"
  # tag "bioinformatics"

  url "https://github.com/sequencing/NxTrim/archive/v0.4.1.tar.gz"
  sha256 "7168196d8175e1f11e08112a522a01f5860ad0f31f8cfd0d9c7aae60649cfe33"
  head "https://github.com/sequencing/NxTrim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6ab2f83521da490f1e68ffc975f439ee9e6a043c244b0b7829a58f67c8b17ac" => :sierra
    sha256 "188a2a54ff17835fbb3d3f0cfe845e6312d88e8c15045356809207adf76b22bf" => :el_capitan
    sha256 "d37598c7b251091ea830efcd72d60d7b2a608b806c02f9d4f3eab319298ca012" => :yosemite
  end

  depends_on "boost"

  def install
    system "make", "BOOST_ROOT=#{Formula["boost"].prefix}"
    bin.install "nxtrim", "mergeReads"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/nxtrim 2>&1")
  end
end
