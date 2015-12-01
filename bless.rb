class Bless < Formula
  homepage "https://sourceforge.net/projects/bless-ec/"
  # doi "10.1093/bioinformatics/btu030"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/bless-ec/bless.v0p24.tgz"
  version "0.24"
  sha256 "4214a7f9277e92c02acc132f0f8ba88e7d05a7fd3135a59fc1c6e52ca37d181a"

  bottle do
    cellar :any
    sha256 "84dae4d11d11a7ba746f753ef457a7b65f3ab189b478bed246281af9828403ff" => :mountain_lion
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
