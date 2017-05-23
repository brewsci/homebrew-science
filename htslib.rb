class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.4.1/htslib-1.4.1.tar.bz2"
  sha256 "85d2dd59ffa614a307d64e9f74a9f999f0912661a8b802ebcc95f537d39933b3"
  head "https://github.com/samtools/htslib.git"
  revision 1
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "f3deeb23141c8761e258be68b011ed5e8a51291c45a2ac6bb75b508acdfd0ce4" => :sierra
    sha256 "b1139910113e0b60cf525f8f30d8172011b2821cc1f7639428de670ab2d3495e" => :el_capitan
    sha256 "1e8e410fcabeb11246a69260cff45a4b837f8be56b225f999c1676d664cd5a62" => :yosemite
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
