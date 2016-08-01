class Bedtools < Formula
  desc "bedtools: A powerful toolset for genome arithmetic"
  homepage "https://github.com/arq5x/bedtools2"
  # doi "10.1093/bioinformatics/btq033"
  # tag "bioinformatics"

  url "https://github.com/arq5x/bedtools2/archive/v2.26.0.tar.gz"
  sha256 "15db784f60a11b104ccbc9f440282e5780e0522b8d55d359a8318a6b61897977"

  head "https://github.com/arq5x/bedtools2.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a90cbab5d09038ac04fc00bf7d05ab9edb5e899fda8a5b0a17a692841ad08ab1" => :el_capitan
    sha256 "00e4d5d86c09c388cfaefe13499a3bb82fd013a68f6879f392c9093f5c81fe0f" => :yosemite
    sha256 "6a23ad1a8f2d661f6e55c196ddfbb66219251ed2349746bd3b09789ee2b01253" => :mavericks
    sha256 "b178c48e7af280abf06954dfbd9a1fcb431ff1e2635447e85117235ab0a945df" => :x86_64_linux
  end

  def install
    system "make"
    prefix.install "bin"
    doc.install %w[README.md RELEASE_HISTORY]
  end

  test do
    system "#{bin}/bedtools", "--version"
  end
end
