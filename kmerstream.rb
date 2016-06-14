class Kmerstream < Formula
  desc "Streaming algorithms for k-mer abundance estimation"
  homepage "https://github.com/pmelsted/KmerStream"
  url "https://github.com/pmelsted/KmerStream/archive/v1.1.tar.gz"
  sha256 "cf5de6224a0dd40e30af4ccc464bb749d20d393a7d4d3fceafab5f3d75589617"
  head "https://github.com/pmelsted/KmerStream.git"
  # doi "10.1093/bioinformatics/btu713"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "1da47f8ed39381d7ac8c79a72e91f4fc898d9013e13c835a0eb5e630893f6784" => :el_capitan
    sha256 "f8528a7f5a74c25f549544b08b08d17d5cc2febb57932e473e0cff37b3a66ecc" => :yosemite
    sha256 "0362b9af59d217c164cf036d77ce2c157124bdef1c76852229bde8c5faccce90" => :mavericks
    sha256 "dfe473f73af618cedb1003c6d0d67f82592fc6297bd64e6b711153c688d4647d" => :x86_64_linux
  end

  needs :openmp

  def install
    system "make"
    bin.install "KmerStream", "KmerStreamJoin", "KmerStreamEstimate.py"
    doc.install "README.md"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/KmerStream 2>&1", 1)
    assert_match "Usage", shell_output("#{bin}/KmerStreamJoin 2>&1", 1)
    assert_match "Usage", shell_output("#{bin}/KmerStreamEstimate.py 2>&1", 1)
  end
end
