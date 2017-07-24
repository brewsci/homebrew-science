class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btr509"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/releases/download/1.5/htslib-1.5.tar.bz2"
  sha256 "a02b515ea51d86352b089c63d778fb5e8b9d784937cf157e587189cb97ad922d"
  head "https://github.com/samtools/htslib.git"

  bottle do
    cellar :any
    sha256 "0f33fac91f81f872a01550de62bcb540f4fd87374002fe3d8201ff49789f9b60" => :sierra
    sha256 "cef8393427aeccd21ccafe960a1dd7787a8c97026034b77e0102f10994392c31" => :el_capitan
    sha256 "6a556ce7eda16a87ffdfdc5b5e9d376acae850336be76bfc3578e5931c69adfc" => :yosemite
    sha256 "9c1e4887760ac2c4fe28c5e7dfeb960c733d1afbdca7c968d3d67529ffe764b0" => :x86_64_linux
  end

  depends_on "xz"
  unless OS.mac?
    depends_on "bzip2"
    depends_on "zlib"
    depends_on "curl"
  end

  def install
    system "./configure", "--enable-libcurl"
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
