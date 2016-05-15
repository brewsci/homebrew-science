class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.7.3.tar.gz"
  sha256 "0a33178d468aa8e2247c46fd601919777634eb8948aeef3acc4e5f96536190ed"
  head "https://github.com/tobiasrausch/delly.git"

  bottle do
    sha256 "a0134734cb84909f9cb94a14a0f7339445c8920656980389b3e7bc30f6f7bc63" => :el_capitan
    sha256 "05f54fe9ce846c36c6e6b2b23ea70970f85f5b8779e48860e321d26d13e62c56" => :yosemite
    sha256 "bbd8fa99b5446b5c6818535a12b14f298ed249469a735f42722874bf7e87473d" => :mavericks
  end

  option "with-binary", "Install a statically linked binary for 64-bit Linux" if OS.linux?

  if build.without? "binary"
    depends_on "bcftools"
    depends_on "boost"
    depends_on "htslib"
  end

  resource "linux-binary" do
    url "https://github.com/tobiasrausch/delly/releases/download/v0.7.3/delly_v0.7.3_CentOS5.4_x86_64bit"
    sha256 "c6dd1fdd89c7e8af9b8b9eca2ea572716b2d010f93a057c614c14439de91142b"
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
    system "delly", "call", "-t", "DEL", "-g", pkgshare/"test/DEL.fa", "-o", testpath/"test.vcf", pkgshare/"test/DEL.bam"
    assert File.exist? testpath/"test.vcf"
  end
end
