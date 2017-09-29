class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  # doi "10.1093/bioinformatics/btr509"
  # tag "bioinformatics"

  url "https://github.com/samtools/htslib/releases/download/1.6/htslib-1.6.tar.bz2"
  sha256 "9588be8be0c2390a87b7952d644e7a88bead2991b3468371347965f2e0504ccb"
  head "https://github.com/samtools/htslib.git"

  bottle do
    cellar :any
    sha256 "08a4b427717a75d9df403195a9dcfa642667a1d1425ff8826161078aa551d9e0" => :high_sierra
    sha256 "c446eef554351d5c3f6c1570f643e6cff3b77a8810076839d66425082883d4d9" => :sierra
    sha256 "2882a334aa155b6dd728ef9a72b482ce7d9bef155e951f98c202aa8a5ea80bad" => :el_capitan
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
