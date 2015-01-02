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
    sha1 "f7b153b5fc129babe4eb41a6a9986dd8491e4460" => :yosemite
    sha1 "e451a3b3335dfa4d76eb0ddc7f6b19cea38db2a2" => :mavericks
    sha1 "b7fc677ade53fc20c51c804e418313cb28ffa0ac" => :mountain_lion
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
