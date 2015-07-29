class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.6.5.tar.gz"
  sha256 "6977001ef3a3eb5049515a4586640f77d60c4f784f7636c7c5cc456912081283"

  head "https://github.com/tobiasrausch/delly.git"

  bottle do
    revision 1
    sha256 "8f1b94f5e9b536a78db5caa6862d2f969d8d97f4fdbadd7a9f21d447db3cc3ab" => :yosemite
    sha256 "f33a6f364585c71c7d73878b232fa34b1d30261414925b9c38cf6a0174fc59f9" => :mavericks
    sha256 "0053d1b53baa99f555cdf463144f41f3c45bc0605581bc46afcd810a7b13e8c7" => :mountain_lion
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
    File.exist? testpath/"test.vcf"
  end
end
