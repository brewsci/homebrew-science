class Dida < Formula
  desc "Distributed Indexing Dispatched Alignment"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/dida"
  # doi "10.1371/journal.pone.0126409"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/dida/releases/1.0.1/dida-1.0.1.tar.gz"
  sha256 "251d8b6d40d061eb7a7c49737a1ce41592b89a6c8647a791fb9d64ff26afd7bd"
  revision 2

  bottle :disable, "needs to be rebuilt with latest open-mpi"

  # Fix error: DIDA must be compiled with a C++ compiler that supports OpenMP threading.
  needs :openmp

  # Fix error: DIDA must be compiled with MPI support.
  depends_on :mpi

  def install
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dida-wrapper", "--version"
  end
end
