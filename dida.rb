class Dida < Formula
  desc "Distributed Indexing Dispatched Alignment"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/dida"
  bottle do
    cellar :any
    sha256 "ed1693e77dd976f0949bb554a3bc226881dcbccb20cd1b6fb696ab3892e26248" => :el_capitan
    sha256 "65df860ef7d86f41538d7ab1ebce3978a578a6b552ae09fd28f058b0d869c413" => :yosemite
    sha256 "2fbf1a21752ea89ddf730f260143df9cdd5b6d7f9909a9ed156b5863c77aa4af" => :mavericks
  end

  # doi "10.1371/journal.pone.0126409"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/dida/releases/1.0.1/dida-1.0.1.tar.gz"
  sha256 "251d8b6d40d061eb7a7c49737a1ce41592b89a6c8647a791fb9d64ff26afd7bd"

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
