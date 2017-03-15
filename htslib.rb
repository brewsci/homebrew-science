class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.4/htslib-1.4.tar.bz2"
  sha256 "5cfc8818ff45cd6e924c32fec2489cb28853af8867a7ee8e755c4187f5883350"
  head "https://github.com/samtools/htslib.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "81d1b5889fbd44e161bab1bf523b9ac3adc6c48eca72ec53a9177fa248278761" => :sierra
    sha256 "f99c193d96d7c08bd6e926becf8008fbace7c42af76bd95c78241d2e2aaf3903" => :el_capitan
    sha256 "2c7824ba8e31a974a1e180590ff44f9be9acca7d81b7a3a4e7a02c4a5dc9539d" => :yosemite
    sha256 "9ef6f8ac6a01b11f7b6b5d614c1ed5754d4b33677699c5a05f0f4d2609d627a9" => :x86_64_linux
  end

  depends_on "xz"

  def install
    system "make", "install", "prefix=#{prefix}"
    pkgshare.install "test"
  end

  test do
    sam = pkgshare/"test/ce#1.sam"
    assert_match "SAM", shell_output("#{bin}/htsfile #{sam}")
    system "#{bin}/bgzip -c #{sam} > sam.gz"
    assert File.exist?("sam.gz")
    system "#{bin}/tabix", "-p", "sam", "sam.gz"
    assert File.exist?("sam.gz.tbi")
  end
end
