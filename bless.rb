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
    sha256 "1d6aa3d5b22b14cf97865246d25909140d4087477cb7863960910b3dacd3a410" => :el_capitan
    sha256 "752caee287ef8fe5250ee778ea2d8a49cb58f8b8bcee8e7abafa93b0305081a6" => :yosemite
    sha256 "05263b62185382a66c784d0e384730223681ace36e9ea6565dac72f053d6a1bc" => :mavericks
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
