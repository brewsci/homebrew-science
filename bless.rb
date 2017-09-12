class Bless < Formula
  desc "Bloom-filter-based error correction tool for NGS reads"
  homepage "https://sourceforge.net/projects/bless-ec/"
  # doi "10.1093/bioinformatics/btu030"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/bless-ec/bless.v0p24.tgz"
  version "0.24"
  sha256 "4214a7f9277e92c02acc132f0f8ba88e7d05a7fd3135a59fc1c6e52ca37d181a"
  revision 4

  bottle do
    cellar :any
    sha256 "53b7ecad83a4c6e5bb7d60612e45ada3506d11485e20e6513dd1064b5ba7dfa5" => :sierra
    sha256 "b072d6c255fd1643df8d26d800406e959198812ad860e4e6ffea9f349a3f921b" => :el_capitan
  end

  needs :openmp

  depends_on "boost"
  depends_on "google-sparsehash" => :build
  depends_on "kmc" => :recommended
  depends_on :mpi

  def install
    # Do not build vendored dependency, kmc.
    inreplace "Makefile", "cd kmc; make CC=$(CC)", ""

    system "make"
    bin.install "bless"
    doc.install "README", "LICENSE"
  end

  test do
    system "#{bin}/bless"
  end
end
