class Bless < Formula
  homepage "https://sourceforge.net/projects/bless-ec/"
  # doi "10.1093/bioinformatics/btu030"
  # tag "bioinformatics"

  url "https://downloads.sourceforge.net/project/bless-ec/bless.v0p24.tgz"
  version "0.24"
  sha1 "95082ceda46ea01ee6b8caa10718de00901a04de"

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
