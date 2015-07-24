class Delly < Formula
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.6.5.tar.gz"
  sha256 "6977001ef3a3eb5049515a4586640f77d60c4f784f7636c7c5cc456912081283"

  head "https://github.com/tobiasrausch/delly.git"

  bottle do
    sha256 "2abe5ca47e8e9de6bd7a38912063841959e6f0ac9ff4bf35ddc1f74e626f009d" => :yosemite
    sha256 "32bf93246a9b613221d5c4144dc7d42f1e85f2b920c30b02f639597a3688f6b8" => :mavericks
    sha256 "f74527a577cf146ac7b72d1f23c8105112fc57c207820dcc4cb08589624c28cf" => :mountain_lion
  end

  option "with-binary", "Install a statically linked binary for 64-bit Linux" if OS.linux?

  if build.without? "binary"
    depends_on "bamtools"
    depends_on "boost"
    depends_on "htslib"
  end

  resource "linux-binary-0.6.5" do
    url "https://github.com/tobiasrausch/delly/releases/download/v0.6.5/delly_v0.6.5_CentOS5.4_x86_64bit"
    sha256 "56ccdbd5e21d3570c7e34c82593e9ef5d86509f23f57e3e364bcd3f5a7e6899c"
  end

  def install
    if build.with? "binary"
      resource("linux-binary-0.6.5").stage do
        bin.install "delly_v0.6.5_CentOS5.4_x86_64bit" => "delly"
      end
    else
      inreplace "Makefile", ".htslib .bamtools .boost", ""
      ENV.append_to_cflags "-I#{Formula["bamtools"].opt_include}/bamtools"
      ENV.append_to_cflags "-I#{Formula["htslib"].opt_include}/htslib"

      system "make", "BAMTOOLS_ROOT=#{Formula["bamtools"].opt_prefix}",
                     "SEQTK_ROOT=#{Formula["htslib"].opt_prefix}",
                     "BOOST_ROOT=#{Formula["boost"].opt_prefix}",
                     "src/delly"
      bin.install "src/delly"
    end
    share.install "test", "variantFiltering"
    doc.install "README.md"
  end

  test do
    system "delly", "--outfile=#{testpath}/test.vcf", share/"test/DEL.bam"
    File.exist? testpath/"test.vcf"
  end
end
