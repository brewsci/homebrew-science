class Bless < Formula
  desc "Bloom-filter-based error correction tool for NGS reads"
  homepage "https://sourceforge.net/projects/bless-ec/"
  # doi "10.1093/bioinformatics/btu030"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/bless-ec/bless.v0p24.tgz"
  version "0.24"
  sha256 "4214a7f9277e92c02acc132f0f8ba88e7d05a7fd3135a59fc1c6e52ca37d181a"
  revision 3

  bottle do
    cellar :any
    sha256 "ddee4154e60f12d4587a75e7493fef3da68d414eb6ab969ff1b69b90a2df9e7e" => :sierra
    sha256 "e7205a00d2381bab2cd4901b017a3bb5bba4bd48ea7bf2a2addde879fda9b0fc" => :el_capitan
    sha256 "2e2e957f828ed0a5edd9dbd8e14637cd8e9c35d2530df8b3ac94a7a83fd01c39" => :yosemite
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
