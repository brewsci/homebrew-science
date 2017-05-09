class Nxtrim < Formula
  desc "Trim adapters for Illumina Nextera Mate Pair libraries"
  homepage "https://github.com/sequencing/NxTrim"
  # doi "10.1101/007666"
  # tag "bioinformatics"

  url "https://github.com/sequencing/NxTrim/archive/v0.4.2.tar.gz"
  sha256 "851dc82e1e503485ae70ea0770563b977a15d7b4dd29c4ca318bec4323355c19"
  head "https://github.com/sequencing/NxTrim.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8becf69c161ebb7dd7352b2e7ba4fbde3d288c0be3267ad14fa128c20188e074" => :sierra
    sha256 "3bbcf6b39105f21d1a7e59be6022272912bf8999ef24f6d0bfbb9cd48a3c1735" => :el_capitan
    sha256 "e40e333b5b4a9e940c47dce69bbb47bd49fec79a84ba20d4bdf67d7788edb09c" => :yosemite
    sha256 "c350dfb9ffdbec63e8c367c84093a9bae671f981f8068f344395baf9dd0c13b1" => :x86_64_linux
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
