class Delly < Formula
  desc "Structural variant discovery by paired-end and split-read analysis"
  homepage "https://github.com/tobiasrausch/delly"
  url "https://github.com/tobiasrausch/delly/archive/v0.7.5.tar.gz"
  sha256 "14daf744e7179b2781cbb88b26f674d1221c0093fec6d33c13a6d2863577598a"
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
