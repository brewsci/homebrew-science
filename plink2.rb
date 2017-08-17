class Plink2 < Formula
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink2"
  url "https://github.com/chrchang/plink-ng/archive/v1.90b3.tar.gz"
  version "1.90b3"
  # doi "10.1186/s13742-015-0047-8"
  # tag "bioinformatics"
  sha256 "2f4afc193c288b13af4410e4587358ee0a6f76ed7c98dd77ca1317aac28adf0d"
  revision 2

  bottle do
    cellar :any
    sha256 "61fba0c9016731531eaab1e88f1fc01d0ccbf41119c084e257e3f999fe8be0ad" => :sierra
    sha256 "87ef1226f0fd076e0683e2b30c006489cb76f2a44b241949cd44beec549a3126" => :el_capitan
    sha256 "540b6a0f57c322040f1338655456a32c7971a3320fdc17d09fba582930c5722e" => :yosemite
  end

  depends_on :fortran
  depends_on "zlib"
  if OS.mac?
    depends_on "openblas" => :optional
  else
    depends_on "openblas" => :recommended
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
