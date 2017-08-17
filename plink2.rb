class Plink2 < Formula
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink2"
  url "https://github.com/chrchang/plink-ng/archive/v1.90b3.tar.gz"
  version "1.90b3"
  # doi "10.1186/s13742-015-0047-8"
  # tag "bioinformatics"
  sha256 "2f4afc193c288b13af4410e4587358ee0a6f76ed7c98dd77ca1317aac28adf0d"
  revision 2
  head "https://github.com/chrchang/plink-ng"

  bottle do
    cellar :any
    sha256 "7811cac3dc634113a738a0b6c73099f14fa480ffa682f651a0f39ab44746c72e" => :sierra
    sha256 "82e91a96292f0577d55249eb7f50fe968f59f51970349b9ad3c8c589508b263d" => :el_capitan
    sha256 "7363e3c00eb1cb2a5542a8239906c01324f7bb4c6096ab3f1df34a20d8148021" => :yosemite
    sha256 "4852a01fe2347772a7566d5aa1d84479f5ed66fa4610d0b4a090c1163f0267d2" => :x86_64_linux
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
