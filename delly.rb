class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.7.6.tar.gz"
  sha256 "fab273f17dacde4e15e18a187bfe47826a1b8396a8aa40b44a68c56f059f79b5"
  revision 1
  head "https://github.com/tobiasrausch/delly.git"
  # doi "10.1093/bioinformatics/bts378"
  # tag "bioinformatics"

  bottle do
    sha256 "804c4abe4f148e882ff20fe957eb7960d36d19f3f9a6bd9ee390a837f608b56c" => :sierra
    sha256 "aba6e25f0d705541eb26b046a0158fa6817e8f8475c46e7e5ef6756738c2e3ec" => :el_capitan
    sha256 "955763136bc7bfdcafe3074f3edc6e544460275f2947866079eb15a7645953f9" => :yosemite
  end

  option "with-binary", "Install a statically linked binary for 64-bit Linux" if OS.linux?

  if build.without? "binary"
    depends_on "bcftools"
    depends_on "boost"
    depends_on "htslib"
  end

  resource "linux-binary" do
    url "https://github.com/tobiasrausch/delly/releases/download/v0.7.5/delly_v0.7.5_CentOS5.4_x86_64bit"
    version "0.7.5"
    sha256 "ffacd99c373b82ef346179868db94af7615877e5fdf6252f797c2a45e984ea99"
  end

  # The tests were removed after 0.6.5, but they still work
  resource "tests" do
    url "https://github.com/tobiasrausch/delly/archive/v0.6.5.tar.gz"
    sha256 "6977001ef3a3eb5049515a4586640f77d60c4f784f7636c7c5cc456912081283"
  end

  def install
    if build.with? "binary"
      resource("linux-binary").stage do
        bin.install "delly_v#{version}_CentOS5.4_x86_64bit" => "delly"
      end
    else
      inreplace "Makefile", ".htslib .bcftools .boost", ""
      ENV.append_to_cflags "-I#{Formula["htslib"].opt_include}/htslib"

      system "make", "SEQTK_ROOT=#{Formula["htslib"].opt_prefix}",
                     "BOOST_ROOT=#{Formula["boost"].opt_prefix}",
                     "src/delly"
      bin.install "src/delly"
    end
    resource("tests").stage { pkgshare.install "test" }
    doc.install "README.md"
  end

  test do
    system bin/"delly", "call", "-t", "DEL", "-g", pkgshare/"test/DEL.fa",
           "-o", "test.vcf", pkgshare/"test/DEL.bam"
    assert File.exist?("test.vcf"), "Failed to create test.vcf!"
  end
end
