class Raxml < Formula
  desc "Maximum likelihood analysis of large phylogenies"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.11.tar.gz"
  sha256 "08cda74bf61b90eb09c229e39b1121c6d95caf182708e8745bd69d02848574d7"
  revision 1
  head "https://github.com/stamatak/standard-RAxML.git"
  # doi "10.1093/bioinformatics/btu033"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "49e39c69a0a8481da8843d4c1c12a613aa38b923dfe93da67c32be49b1737908" => :sierra
    sha256 "b20dc20c72c2c9a0581f2bff4bb886aafec3a4dc0d23ac5f3954d04cb80f6968" => :el_capitan
    sha256 "81072691c75f086e3d2b4e559d07a006491c61f51589c9644dfc0b785f5b9afb" => :yosemite
    sha256 "c9ee28f10415e58cfe33d7cfe4e03bef934ab81fd6482578fadd925271ff2d75" => :x86_64_linux
  end

  depends_on :fortran

  # Won't build on OS X - relies on Linux-specific threading APIs
  depends_on :mpi => [:cc, :optional] if OS.linux?
  needs :openmp if build.with? "mpi"

  def make_clean(makefile)
    rm Dir["*.o"]
    system "make", "-f", makefile
  end

  def install
    make_clean "Makefile.PTHREADS.gcc"
    make_clean "Makefile.SSE3.PTHREADS.gcc" if Hardware::CPU.sse3?
    make_clean "Makefile.AVX.PTHREADS.gcc" if Hardware::CPU.avx?
    make_clean "Makefile.AVX2.PTHREADS.gcc" if Hardware::CPU.avx2?

    if build.with? "mpi"
      make_clean "Makefile.HYBRID.gcc"
      make_clean "Makefile.SSE3.HYBRID.gcc" if Hardware::CPU.sse3?
      make_clean "Makefile.AVX.HYBRID.gcc" if Hardware::CPU.avx?
      make_clean "Makefile.AVX2.HYBRID.gcc" if Hardware::CPU.avx2?
      make_clean "Makefile.MPI.gcc"
      make_clean "Makefile.SSE3.MPI.gcc" if Hardware::CPU.sse3?
      make_clean "Makefile.AVX.MPI.gcc" if Hardware::CPU.avx?
      make_clean "Makefile.AVX2.MPI.gcc" if Hardware::CPU.avx2?
    end

    bin.install Dir["raxmlHPC-*"]
  end

  test do
    (testpath/"aln.phy").write <<-EOS.undent
       10 60
      Cow       ATGGCATATCCCATACAACTAGGATTCCAAGATGCAACATCACCAATCATAGAAGAACTA
      Carp      ATGGCACACCCAACGCAACTAGGTTTCAAGGACGCGGCCATACCCGTTATAGAGGAACTT
      Chicken   ATGGCCAACCACTCCCAACTAGGCTTTCAAGACGCCTCATCCCCCATCATAGAAGAGCTC
      Human     ATGGCACATGCAGCGCAAGTAGGTCTACAAGACGCTACTTCCCCTATCATAGAAGAGCTT
      Loach     ATGGCACATCCCACACAATTAGGATTCCAAGACGCGGCCTCACCCGTAATAGAAGAACTT
      Mouse     ATGGCCTACCCATTCCAACTTGGTCTACAAGACGCCACATCCCCTATTATAGAAGAGCTA
      Rat       ATGGCTTACCCATTTCAACTTGGCTTACAAGACGCTACATCACCTATCATAGAAGAACTT
      Seal      ATGGCATACCCCCTACAAATAGGCCTACAAGATGCAACCTCTCCCATTATAGAGGAGTTA
      Whale     ATGGCATATCCATTCCAACTAGGTTTCCAAGATGCAGCATCACCCATCATAGAAGAGCTC
      Frog      ATGGCACACCCATCACAATTAGGTTTTCAAGACGCAGCCTCTCCAATTATAGAAGAATTA
    EOS

    system "#{bin}/raxmlHPC-PTHREADS", "-f", "a", "-m", "GTRGAMMA", "-p",
                                       "12345", "-x", "12345", "-N", "100",
                                       "-s", "aln.phy", "-n", "test", "-T", "2"
    assert File.exist?("RAxML_bipartitions.test"), "Failed to create RAxML_bipartitions.test!"
  end
end
