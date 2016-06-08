class Raxml < Formula
  desc "maximum likelihood analysis of large phylogenies"
  homepage "http://sco.h-its.org/exelixis/web/software/raxml/index.html"
  url "https://github.com/stamatak/standard-RAxML/archive/v8.2.8.tar.gz"
  sha256 "a99bd3c5fcd640eecd6efa3023f5009c13c04a9b1cea6598c53daa5349f496b6"
  head "https://github.com/stamatak/standard-RAxML.git"
  # doi "10.1093/bioinformatics/btu033"
  # tag "bioinformatics"

  bottle do
    cellar :any_skip_relocation
    sha256 "d0d39ab71339020bc78efffb9b9c75fdebcd8ffdfeeafa9826647ff52015d46f" => :el_capitan
    sha256 "c8a40920c9c849ba89affda772bcddbe6736bd12e03efd75b1430d760ecb4871" => :yosemite
    sha256 "bc4002fd54bea1592e7e2554c5d94dccb506612b4455e25332c0b26c806b7b0d" => :mavericks
    sha256 "9e017cb21b49b6ef20597dfd806bff25e072db052fdb262e853345172cafc3bc" => :x86_64_linux
  end

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

    system *%W[raxmlHPC-PTHREADS -f a -m GTRGAMMA -p 12345 -x 12345 -N 100 -s aln.phy -n test -T 2]
    File.exist? "RAxML_bipartitions.test"
  end
end
