class Kaiju < Formula
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "http://kaiju.binf.ku.dk/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/v1.4.2.tar.gz"
  sha256 "cf18a12a9ae5a5a37532c80928f0dea8d08d2f99295123d2d1937d278ab9d137"
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
    system "#{bin}/kaiju", "-h"
  end
end
