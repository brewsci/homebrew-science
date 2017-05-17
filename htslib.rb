class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.4.1/htslib-1.4.1.tar.bz2"
  sha256 "85d2dd59ffa614a307d64e9f74a9f999f0912661a8b802ebcc95f537d39933b3"
  head "https://github.com/samtools/htslib.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "e1c2fbc842d5edd82ab9d35ea150d704bb8e71a90e0e2feb7e226103800586c3" => :sierra
    sha256 "9216fa9aa7903bd89845beec64781024197e19bda0ddd1edbe5430c6c72b6df9" => :el_capitan
    sha256 "b95ff2cb774640903aeeb0a660dd88b028138904f138aded6893b667a7bd7f81" => :yosemite
    sha256 "76309a51fd20adc05a9dbcae498d841ce294ae1756d7ec211c6fd855fbd51729" => :x86_64_linux
  end

  depends_on "xz"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
  end

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
