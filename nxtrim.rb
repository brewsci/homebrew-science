class Nxtrim < Formula
  desc "Trim adapters for Illumina Nextera Mate Pair libraries"
  homepage "https://github.com/sequencing/NxTrim"
  # doi "10.1101/007666"
  # tag "bioinformatics"

  url "https://github.com/sequencing/NxTrim/archive/v0.4.2.tar.gz"
  sha256 "851dc82e1e503485ae70ea0770563b977a15d7b4dd29c4ca318bec4323355c19"
  revision 1
  head "https://github.com/sequencing/NxTrim.git"

  bottle :disable, "needs to be rebuilt with latest boost"

  depends_on "boost"

  def install
    system "make", "BOOST_ROOT=#{Formula["boost"].prefix}"
    bin.install "nxtrim", "mergeReads"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/nxtrim 2>&1")
  end
end
