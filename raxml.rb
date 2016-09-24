class Raxml < Formula
  desc "maximum likelihood analysis of large phylogenies"
  homepage "http://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.9.tar.gz"
  sha256 "c7e12c8a4437e006b574d40520c8169f4bdcf7eda732e2930ac21fe39db868df"
  head "https://github.com/stamatak/standard-RAxML.git"
  # doi "10.1093/bioinformatics/btu033"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "1b56bcbb1ec4bdaf975abaff4d882a63b116092c6be1ce4bc689f1c264f42901" => :el_capitan
    sha256 "f9147f80719097fa89861303f2c56364dbe0ab1073fcd72664c9d08773d00a11" => :yosemite
    sha256 "a0dc1c7055d184a3aca26f9a3dbbd922877347200968ac90b4a4f79196956b57" => :mavericks
    sha256 "9dd4021dcd5ea7c9edcb8ebd419649814d9c22ec3cb7e07155821913b15362ba" => :x86_64_linux
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

    system *%W[#{bin}/raxmlHPC-PTHREADS -f a -m GTRGAMMA -p 12345 -x 12345 -N 100 -s aln.phy -n test -T 2]
    assert File.exist?("RAxML_bipartitions.test"), "Failed to create RAxML_bipartitions.test!"
  end
end
