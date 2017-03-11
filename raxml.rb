class Raxml < Formula
  desc "maximum likelihood analysis of large phylogenies"
  homepage "http://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.10.tar.gz"
  sha256 "48f9f4e6bcdcdae59ce6c895abfe35dadbbf4d0faf71ebb532d9b1e6ae56478f"
  head "https://github.com/stamatak/standard-RAxML.git"
  # doi "10.1093/bioinformatics/btu033"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "6e24a50402bed191bc6408684d49f549fe3b123df3bbfdeea38f71294bf108db" => :sierra
    sha256 "a952899dd6895562b04933bd36f949ed6a2f6b0adac81dd73d6d5b0b8c729901" => :el_capitan
    sha256 "5bbefd6686b30e50d7eef66a9f5cc59de7cd873666c6fd5eb9bffab46e719e01" => :yosemite
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
