class Bedtools < Formula
  homepage "https://github.com/arq5x/bedtools2"
  desc "bedtools: A powerful toolset for genome arithmetic"
  # doi "10.1093/bioinformatics/btq033"
  # tag "bioinformatics"

  url "https://github.com/arq5x/bedtools2/archive/v2.24.0.tar.gz"
  sha256 "74dd9dbbdf47ef055a1fb8fc9f2f400d0a381e0f4f4d5d1759d5daa1b7ccdd52"

  head "https://github.com/arq5x/bedtools2.git"

  bottle do
    cellar :any
    sha256 "5f1fcc24f01e23dafb14a492b276f749f54be2c64bf1570eb4410d170043f649" => :yosemite
    sha256 "ecae0fef48e1a28abb1acec96408cd4c3236e52da188daaa9f2eaf8368526b44" => :mavericks
    sha256 "6a9e646386fc5eef3f3d5fff8cb5ad13f6c4bf3d377e9fa393f088b024bc0c1f" => :mountain_lion
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
