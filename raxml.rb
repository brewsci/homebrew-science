class Raxml < Formula
  desc "maximum likelihood analysis of large phylogenies"
  homepage "https://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.11.tar.gz"
  sha256 "08cda74bf61b90eb09c229e39b1121c6d95caf182708e8745bd69d02848574d7"
  head "https://github.com/stamatak/standard-RAxML.git"
  # doi "10.1093/bioinformatics/btu033"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9bdb3b4207493c41e5546c16a121a323be4b361525659f8202ff027f4b82f7d" => :sierra
    sha256 "33954b279ee15d58256589150638ca7eb517bbac6fe64d143efaa6b71b4b9b10" => :el_capitan
    sha256 "c03a4f9c11552b6c718ab5a3efac8cae96fbd54839f4524130db5b9f8bb8d1fb" => :yosemite
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
