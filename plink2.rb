class Plink2 < Formula
  url "https://github.com/chrchang/plink-ng/archive/v1.90b3.tar.gz"
  version "1.90b3"
  # doi "10.1186/s13742-015-0047-8"
  # tag "bioinformatics"
  homepage "https://www.cog-genomics.org/plink2"
  sha256 "2f4afc193c288b13af4410e4587358ee0a6f76ed7c98dd77ca1317aac28adf0d"

  depends_on :fortran
  depends_on "openblas" => :optional
  depends_on "homebrew/dupes/zlib"

  bottle do
    cellar :any
    revision 1
    sha256 "02fcc689eaa65c3a2125ae9431c8c023856a17a39c0df8b10d073aca31019ded" => :yosemite
    sha256 "90b3d7eb2189afc68c05764cc88c826b5cd72386fa0e66b779ce439fb052c7e5" => :mavericks
    sha256 "912423fe36c51e093ee43ae8d35382a1ebdff619ce197a88ff0193498f27e85b" => :mountain_lion
  end

  def install
    mv "Makefile.std", "Makefile"
    ln_s Formula["zlib"].opt_include, "zlib-1.2.8"
    cflags = "-Wall -O2 -flax-vector-conversions"
    cflags += " -I#{Formula["openblas"].opt_include}" if build.with? "openblas"
    args = ["CFLAGS=#{cflags}", "ZLIB=-L#{Formula["zlib"].opt_lib} -lz"]
    args << "BLASFLAGS=-L#{Formula["openblas"].opt_lib} -lopenblas" if build.with? "openblas"
    system "make", "plink", *args
    bin.install "plink" => "plink2"
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert File.exist?("dummy_cc1.bed")
  end
end
