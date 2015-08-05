class Htsbox < Formula
  desc "Experimental tools on top of htslib"
  homepage "https://github.com/lh3/htsbox"
  # tag "bioinformatics"

  url "https://github.com/lh3/htsbox/archive/1b2dee28b52f28afdd14510f551e6aaf658efa8d.tar.gz"
  version "r311"
  sha256 "9a1e8bee4527973d1c4f27203a959380ea266cc23ad7d3a51d530815d0ec6ec4"

  head "https://github.com/lh3/htsbox.git"

  bottle do
    cellar :any
    sha1 "4a0b008515d88edea4307d336da15b9950a6e170" => :yosemite
    sha1 "26662eaaea1233820256298ba6788fbc3d5dc1fc" => :mavericks
    sha1 "74cf4e471b03bfb74e52ed92b6a01a159bfc7d56" => :mountain_lion
  end

  depends_on "htslib"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "htsbox"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/htsbox 2>&1", 1)
  end
end
