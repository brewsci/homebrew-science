class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.7.7.tar.gz"
  sha256 "72298ef36be82fa0bd83c77c9c38d5bac48c9219595f1a206c26d6eeeff07c36"
  revision 4
  head "https://github.com/tobiasrausch/delly.git"
  # doi "10.1093/bioinformatics/bts378"
  # tag "bioinformatics"

  bottle :disable, "needs to be rebuilt with latest boost"

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
