class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.4/htslib-1.4.tar.bz2"
  sha256 "5cfc8818ff45cd6e924c32fec2489cb28853af8867a7ee8e755c4187f5883350"
  head "https://github.com/samtools/htslib.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "e1c2fbc842d5edd82ab9d35ea150d704bb8e71a90e0e2feb7e226103800586c3" => :sierra
    sha256 "9216fa9aa7903bd89845beec64781024197e19bda0ddd1edbe5430c6c72b6df9" => :el_capitan
    sha256 "b95ff2cb774640903aeeb0a660dd88b028138904f138aded6893b667a7bd7f81" => :yosemite
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
