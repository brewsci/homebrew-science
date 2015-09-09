class Bedtools < Formula
  homepage "https://github.com/arq5x/bedtools2"
  desc "bedtools: A powerful toolset for genome arithmetic"
  # doi "10.1093/bioinformatics/btq033"
  # tag "bioinformatics"

  url "https://github.com/arq5x/bedtools2/archive/v2.25.0.tar.gz"
  sha256 "159122afb9978015f7ec85d7b17739b01415a5738086b20a48147eeefcf08cfb"

  head "https://github.com/arq5x/bedtools2.git"

  bottle do
    cellar :any
    sha256 "8246a5d3e65c550b5881c3243f13a9580564446f9ec66d1585e5f0355cd7ecd4" => :yosemite
    sha256 "a3258bc5227735ee8cc1fe20a2dfd1a1ec94d0eb9c559db62298405f56aafaef" => :mavericks
    sha256 "ed5cdb74539d9feab382d7a20c9648a2a31101f7870916761430a96031062136" => :mountain_lion
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
