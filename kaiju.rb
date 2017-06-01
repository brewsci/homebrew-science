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
    sha256 "83d0ca10f86875d29fc6312b17b012d12c10f3af6dab1b61b2e832f87651aed7" => :sierra
    sha256 "5143dbaaea8fe258c67cf19a17cbe958c3eef2fbd38bb224036acba9bfb3c089" => :el_capitan
    sha256 "11ccc63d76f9e131aa600a291eff87e4ded5a9d6bf0812081843fed161c1b977" => :yosemite
    sha256 "deea5e8ee85e4094ab0ede7950d5657dde8e2206f488511cd639f663279882cd" => :x86_64_linux
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
