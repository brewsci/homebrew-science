class Bless < Formula
  desc "Bloom-filter-based error correction tool for NGS reads"
  homepage "https://sourceforge.net/projects/bless-ec/"
  # doi "10.1093/bioinformatics/btu030"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/bless-ec/bless.v0p24.tgz"
  version "0.24"
  sha256 "4214a7f9277e92c02acc132f0f8ba88e7d05a7fd3135a59fc1c6e52ca37d181a"
  revision 2

  bottle do
    cellar :any
    sha256 "46a8bd6d5699ad1b0efe883f7251df9cc311703e8bf50b11fd9b047be26eac37" => :el_capitan
    sha256 "22aaba93a4dd391b3f7c333d4a2e5a4055f2a8ac2c4736d80eaad1512f81b5b3" => :yosemite
    sha256 "812b82ba635fe5812bd933c3d0120322c5d9d1faf26d13c499496c4937e9bc23" => :mavericks
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
