class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.6.5.tar.gz"
  sha256 "6977001ef3a3eb5049515a4586640f77d60c4f784f7636c7c5cc456912081283"

  head "https://github.com/tobiasrausch/delly.git"

  bottle do
    revision 2
    sha256 "d2a48e7fdbc7b882229ae93a5b88b97d205e80f0d58267447046e77222b46e05" => :el_capitan
    sha256 "9bf3951e12708387e40dbe9ef69e17a5bcedfd9db07316d1547f9e7dedcf5477" => :yosemite
    sha256 "727334bbad58f8d5f4344a6567d0ce411ef86aad681dff75b2ece00951125948" => :mavericks
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
    pkgshare.install "test", "variantFiltering"
    doc.install "README.md"
  end

  test do
    system "delly", "--outfile=#{testpath}/test.vcf", pkgshare/"test/DEL.bam"
    assert File.exist? testpath/"test.vcf"
  end
end
