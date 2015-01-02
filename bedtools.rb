require "formula"

class Bedtools < Formula
  homepage "https://github.com/arq5x/bedtools2"
  #doi "10.1093/bioinformatics/btq033"
  #tag "bioinformatics"
  url "https://github.com/arq5x/bedtools2/releases/download/v2.22.1/bedtools-2.22.1.tar.gz"
  sha1 "910d18a73b17f5c89abffc71228c2aeb4b608fac"
  head "https://github.com/arq5x/bedtools2.git"

  bottle do
    root_url "https://downloads.sf.net/project/machomebrew/Bottles/science"
    cellar :any
    sha1 "8c42e2006d59cbe8510acb245f2045602c7145b7" => :yosemite
    sha1 "552196fd1fe129e24814ae0c6ddaa58baf6f7535" => :mavericks
    sha1 "e94f17b8d473ebb26fb0acd7936bf268327f78b5" => :mountain_lion
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
