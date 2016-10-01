class Kaiju < Formula
  desc "Fast taxonomic classification of metagenomic sequencing reads"
  homepage "http://kaiju.binf.ku.dk/"
  url "https://github.com/bioinformatics-centre/kaiju/archive/v1.4.2.tar.gz"
  sha256 "cf18a12a9ae5a5a37532c80928f0dea8d08d2f99295123d2d1937d278ab9d137"
  head "https://github.com/bioinformatics-centre/kaiju.git"
  # tag "bioinformatics"
  # doi "10.1038/ncomms11257"

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
