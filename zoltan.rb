class Zoltan < Formula
  desc "Zoltan: Parallel Partitioning, Load Balancing and Data-Management"
  homepage "http://www.cs.sandia.gov/Zoltan"
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.83.tar.gz"
  sha256 "d0d78fdeab7a385c87d3666b8a8dc748994ff04d3fd846872a4845e12d79c1bb"

  bottle do
    sha256 "133207543f781aa413062f7ecbe80b89e76b96577b62fe150727fa9f499a6d3c" => :yosemite
    sha256 "970454cab90e1c4ed9cccd2042c704d4122a4cfe59d5044d8b193bfcefe8fbe2" => :mavericks
    sha256 "d60f28375337061ea183d9e1112018498ad6dc33acbeaf5764a461b30ad797d5" => :mountain_lion
  end

  option "without-test", "Skip build-time tests (not recommended)"

  deprecated_option "without-check" => "without-test"

  depends_on "scotch"   => :optional
  depends_on "parmetis" => :optional
  depends_on :fortran   => :optional

  mpilang = [:cc, :cxx]
  mpilang << :f90 if build.with? :fortran
  depends_on :mpi => mpilang

  def install
    args = [
      "--prefix=#{prefix}",
      "CC=#{ENV["MPICC"]}",
      "CXX=#{ENV["MPICXX"]}",
    ]
    args << "--with-scotch" if build.with? "scotch"
    args << "--with-parmetis" if build.with? "parmetis"
    args += ["--enable-f90interface", "FC=#{ENV["MPIFC"]}"] if build.with? :fortran

    mkdir "zoltan-build" do
      system "../configure", *args
      system "make", "everything"
      system "make", "check" if build.with? "check"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include "zoltan.h"
      int main(int argc, char *argv[])
      {
        MPI_Init(NULL, NULL);
        struct Zoltan_Struct *z = Zoltan_Create(MPI_COMM_SELF);
        if (!z)
          return -1;
        Zoltan_Destroy(&z);
        MPI_Finalize();
        printf(\"%f\\n\", ZOLTAN_VERSION_NUMBER);
        return 0;
      }
    EOS
    system "mpicc", "test.c", "-o", "test", "-lzoltan"
    system "./test"
  end
end
