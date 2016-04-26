class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/archive/1.3.1.tar.gz"
  sha256 "3bbd04f9a0c4c301abd5d19a81920894ac2ee5e86e8aa977e8c2035e01d93ea7"
  head "https://github.com/samtools/htslib.git"

  bottle do
    cellar :any
    sha256 "6a108162edc562064b258193b4f1984d70589e636ac914bfcb214b6cbd80da7e" => :el_capitan
    sha256 "82d069f0e0603bf7417d2713e7011ee5c066d840ea91ec888971666e8950eb97" => :yosemite
    sha256 "4dd02f91988651c213b1f84b79d938e06cea297b35e11baefe2e12e016c5b171" => :mavericks
  end

  conflicts_with "tabix", :because => "both htslib and tabix install bin/tabix"

  def install
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    sam = pkgshare/"test/ce#1.sam"
    assert_match "SAM", shell_output("htsfile #{sam}")
    system "bgzip -c #{sam} > sam.gz"
    assert File.exist?("sam.gz")
    system "tabix", "-p", "sam", "sam.gz"
    assert File.exist?("sam.gz.tbi")
  end
end
