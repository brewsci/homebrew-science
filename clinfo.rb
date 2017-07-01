class Clinfo < Formula
  desc "Print information about OpenCL platforms and devices"
  homepage "https://github.com/Oblomov/clinfo"
  url "https://github.com/Oblomov/clinfo/archive/2.2.17.06.14.tar.gz"
  sha256 "6179a92bbe1893b7c5b1dff7c8eaba277c194870d17039addf2d389cbb68b87e"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa3c52d03e5b9352eeb08690aebee470123efd73815de391bcce9b4f37fa02d2" => :sierra
    sha256 "1d0e603def9babd4637fa6b27de94c5b24f7e4071617e7163f8c30c3af01b532" => :el_capitan
    sha256 "404d014e917705167154f3ccdf9c43e2c993a5385a29295ce275669c4291d55b" => :yosemite
  end

  def install
    system "make"
    bin.install "clinfo"
    man1.install "man/clinfo.1"
  end

  test do
    output = shell_output bin/"clinfo"
    assert_match /Device Type +CPU/, output
  end
end
