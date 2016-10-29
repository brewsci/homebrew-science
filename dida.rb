class Dida < Formula
  desc "Distributed Indexing Dispatched Alignment"
  homepage "http://www.bcgsc.ca/platform/bioinfo/software/dida"
  # doi "10.1371/journal.pone.0126409"
  # tag "bioinformatics"

  url "http://www.bcgsc.ca/platform/bioinfo/software/dida/releases/1.0.1/dida-1.0.1.tar.gz"
  sha256 "251d8b6d40d061eb7a7c49737a1ce41592b89a6c8647a791fb9d64ff26afd7bd"
  revision 1

  bottle do
    cellar :any
    sha256 "38e35d907cb2841dc82b94de93d5323c3b8136d7e0ff4a0e97e2c96c46529232" => :el_capitan
    sha256 "6d221aa3bbb2d3886906b75d021dae0534f40de5ee6173488c0aa5b70e411396" => :yosemite
    sha256 "09d21a097b6b1caa7fbb33b69c09500115f8d5c49a47da810ce64b972593eebb" => :mavericks
    sha256 "1da64c7a7cbd22ace38891cf5d896138c126488a48123900fa6e57faf6cc39d3" => :x86_64_linux
  end

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
