class Bedtools < Formula
  homepage "https://github.com/arq5x/bedtools2"
  desc "bedtools: A powerful toolset for genome arithmetic"
  # doi "10.1093/bioinformatics/btq033"
  # tag "bioinformatics"

  url "https://github.com/arq5x/bedtools2/archive/v2.24.0.tar.gz"
  sha256 "74dd9dbbdf47ef055a1fb8fc9f2f400d0a381e0f4f4d5d1759d5daa1b7ccdd52"

  head "https://github.com/arq5x/bedtools2.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    cellar :any
    sha1 "9d63ea92161b5144b234e9247f28574e2c24797d" => :yosemite
    sha1 "b7caff266b94c391b8fba0c8aeee7486a101d148" => :mavericks
    sha1 "d003c70d8175fd80de939cc65e87b8c37456bc23" => :mountain_lion
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
