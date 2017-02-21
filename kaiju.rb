class Kaiju < Formula
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "http://kaiju.binf.ku.dk/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/v1.5.0.tar.gz"
  sha256 "7a36b9eab08f2e0b288245fe1b34472168f856825962cbe74ac327eea872cb29"
  head "https://github.com/bioinformatics-centre/kaiju.git"
  # tag "bioinformatics"
  # doi "10.1038/ncomms11257"

  bottle do
    cellar :any_skip_relocation
    sha256 "499974be14c54c90110e2a83a739ebb9eab04c2c9ea826079c13320aad51c27e" => :sierra
    sha256 "7f153714f6ca82b32ece4d1204aa7e625c777a5929cccf1e575916dfcf2f6e7c" => :el_capitan
    sha256 "02ffa74401420205885e4433db256a45033d2a642942c0d87df4f19155591da3" => :yosemite
    sha256 "b9fa0b040e3659fb5239306ddaef027060d030935befbc9a2920d67482118c07" => :x86_64_linux
  end

  def install
    cd "src" do
      system "make"
    end
    rm "bin/taxonlist.tsv"
    bin.install Dir["bin/*"]
  end

  test do
    system "#{bin}/mkbwt", "-h"
  end
end
