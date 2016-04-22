class Nxtrim < Formula
  desc "Trim adapters for Illumina Nextera Mate Pair libraries"
  homepage "https://github.com/sequencing/NxTrim"
  # doi "10.1101/007666"
  # tag "bioinformatics"

  url "https://github.com/sequencing/NxTrim/archive/v0.4.0.tar.gz"
  sha256 "aaa2dafefa1c0cca5966d8290eef758cfcca87426a2ba019506c4f38309161ea"
  head "https://github.com/sequencing/NxTrim.git"

  bottle do
    sha256 "0d38dfae7d61a540813ecf3c689e34ba33cee3e02b330f36b4d8886e69e7d14a" => :yosemite
    sha256 "ce8c5c57dd26b897c0d436ec145614e58f2941345226e55215920581e3c961a7" => :mavericks
    sha256 "7b9be71a0acea2373f8664f0a08ae672228afde4b90812a54016b61df76655d4" => :mountain_lion
  end

  depends_on "boost"

  def install
    system "make", "BOOST_ROOT=#{Formula["boost"].prefix}"
    bin.install "nxtrim", "mergeReads"
    doc.install "Changelog", "LICENSE.txt", "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/nxtrim 2>&1")
  end
end
