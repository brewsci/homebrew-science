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
    sha256 "22e8ce50d637f586ba2fcfed72377f8c7d7ffdce801fe0f90d701fdc6b6ad705" => :yosemite
    sha256 "2c5bffccb04d1defd9b49e5568e4aec4c1e265674b5bf6f2f33bf89d02e464bc" => :mavericks
    sha256 "166d431cace37bbb1c96c7dd6d9d47cfefefc0ee0fbcc9bb61289364834050e8" => :mountain_lion
    sha256 "44db59085ab672c7aa2cdbc40b373fffef1c8e71ca9dbb8dbed2afa9c0914f9c" => :x86_64_linux
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
