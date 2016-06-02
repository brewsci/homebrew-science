class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/archive/1.3.1.tar.gz"
  sha256 "3bbd04f9a0c4c301abd5d19a81920894ac2ee5e86e8aa977e8c2035e01d93ea7"
  head "https://github.com/samtools/htslib.git"

  bottle do
    cellar :any
    revision 1
    sha256 "b6841595738c705309e0252b48aac1f718fba2e5b98dedc2a3b98a4e87b1c546" => :el_capitan
    sha256 "be89111d41c0d0a8e446165526d32d96f87fc522d9107e81d0cd326a0e4dd617" => :yosemite
    sha256 "34cfda10522418051ffee9124b352725b230de9764d4278c377c729ba685053f" => :mavericks
    sha256 "65a8c4e9e3284ff1ad157ce9c4a2c432ef7579a5c145bf23350965244de9bb57" => :x86_64_linux
  end

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
