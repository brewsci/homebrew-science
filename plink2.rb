class Plink2 < Formula
  desc "Analyze genotype and phenotype data"
  homepage "https://www.cog-genomics.org/plink2"
  url "https://github.com/chrchang/plink-ng/archive/b15c19f.tar.gz"
  version "1.90b5"
  # doi "10.1186/s13742-015-0047-8"
  # tag "bioinformatics"
  sha256 "e00ef16ac5abeb6b4c4d77846bd655fafc62669fbebf8cd2e941f07b3111907e"
  head "https://github.com/chrchang/plink-ng"

  bottle do
    cellar :any
    sha256 "a80384d9c7352f2d2d09a084e1cbfdaac2d57bee13bfa0a1fec17e82c1b4a7a5" => :high_sierra
    sha256 "33143ac6b7d5a55c5b9e0a449cae07e984d55ed8686665e8c2bef6bab0610e78" => :sierra
    sha256 "2dd10c934fbb83989e7bf6a014486722b2dd4f15e6fcf5158dbabbc6a4c78ed3" => :el_capitan
    sha256 "8f3c2077963875b459087b242eefc3551409a60befa6ce447b961c81b10f097f" => :x86_64_linux
  end

  depends_on :fortran
  depends_on "zlib"
  if OS.mac?
    depends_on "openblas" => :optional
  else
    depends_on "openblas" => :recommended
  end

  def install
    ln_s Formula["zlib"].opt_include, "zlib-1.2.11"
    cd "1.9"
    mv "Makefile.std", "Makefile"

    args = ["ZLIB=-L#{Formula["zlib"].opt_lib} -lz"]
    cflags = "-Wall -O2 -flax-vector-conversions"

    if build.with? "openblas"
      args << "BLASFLAGS=-L#{Formula["openblas"].opt_lib} -lopenblas"
      cflags += " -I#{Formula["openblas"].opt_include}"
    else
      args << "BLASFLAGS=-framework Accelerate"
    end

    args << "CFLAGS=#{cflags}"

    system "make", "plink", *args
    bin.install "plink" => "plink2"
  end

  test do
    system "#{bin}/plink2", "--dummy", "513", "1423", "0.02", "--out", "dummy_cc1"
    assert_predicate testpath/"dummy_cc1.bed", :exist?
  end
end
