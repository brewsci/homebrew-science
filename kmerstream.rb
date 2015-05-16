class Kmerstream < Formula
  homepage "https://github.com/pmelsted/KmerStream"
  # tag "bioinformatics"
  # doi "10.1101/003962"
  url "https://github.com/pmelsted/KmerStream/archive/v1.0.tar.gz"
  sha256 "65372515dc19fb30c89f912c4a8c302ee3b266e931bbb2983e232e1c9ea62efe"
  head "https://github.com/pmelsted/KmerStream.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha256 "22e8ce50d637f586ba2fcfed72377f8c7d7ffdce801fe0f90d701fdc6b6ad705" => :yosemite
    sha256 "2c5bffccb04d1defd9b49e5568e4aec4c1e265674b5bf6f2f33bf89d02e464bc" => :mavericks
    sha256 "166d431cace37bbb1c96c7dd6d9d47cfefefc0ee0fbcc9bb61289364834050e8" => :mountain_lion
  end

  needs :openmp

  def install
    system "make"
    bin.install "KmerStream"
  end

  test do
    system "#{bin}/KmerStream 2>&1 |grep KmerStream"
  end
end
