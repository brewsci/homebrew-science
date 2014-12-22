class Nxtrim < Formula
  homepage "https://github.com/sequencing/NxTrim"
  #doi "10.1101/007666"
  #tag "bioinformatics"

  url "https://github.com/sequencing/NxTrim/archive/v0.3.0-alpha.tar.gz"
  version "0.3.0"
  sha1 "6502be8546b8d0ebc0120cc2791aefd26471e8a4"

  depends_on "boost"

  def install
    system "make", "BOOST_ROOT=#{Formula["boost"].prefix}"
    bin.install "nxtrim", "mergeReads"
    doc.install "Changes", "LICENSE.txt", "README.md"
  end

  test do
    system "#{bin}/nxtrim -h |grep NxTrim"
  end
end
