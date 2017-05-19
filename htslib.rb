class Htslib < Formula
  desc "C library for high-throughput sequencing data formats"
  homepage "http://www.htslib.org/"
  url "https://github.com/samtools/htslib/releases/download/1.4.1/htslib-1.4.1.tar.bz2"
  sha256 "85d2dd59ffa614a307d64e9f74a9f999f0912661a8b802ebcc95f537d39933b3"
  head "https://github.com/samtools/htslib.git"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "3b079a762853ed36602f79da9ccb75f6f16f9e0e244b1214dfdd541602c9473a" => :sierra
    sha256 "bfe64ac536f3f031bf762a38d4f8eca97bd37a3582335bdcdd711f297df1e704" => :el_capitan
    sha256 "6bc74f519504bb26a6dfa1c244b7058d2a1b4f718d79e9fb6a03b73275a15cad" => :yosemite
    sha256 "2f2c246cda3f7a2616f1240121fbdfd06efb38124d251103eff63bc65d575de3" => :x86_64_linux
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
