class Zoltan < Formula
  desc "Zoltan: Parallel Partitioning, Load Balancing and Data-Management"
  homepage "http://www.cs.sandia.gov/Zoltan"
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.83.tar.gz"
  sha256 "d0d78fdeab7a385c87d3666b8a8dc748994ff04d3fd846872a4845e12d79c1bb"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "8e93c8dbbd9f7df20fbd5d3da95a85766a82230fb12078e5e8f0c2c665dd48e3" => :el_capitan
    sha256 "7714a986f1f3cc1a2b761758715cddaaf2a78b1656d075b513e089206fe15335" => :yosemite
    sha256 "f5637e0318ca0045b480eb8ce3525d15facf464a7d0ea54a9034a9b55cd01f12" => :mavericks
  end

  keg_only "conflicts with trilinos"

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

  def caveats;<<-EOS.undent
    To link against Zoltan, add
      #{opt_include}
    to the search path for includes and
      #{opt_lib}
    to the library search path.
    EOS
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
    system "mpicc", "-I#{opt_include}", "test.c", "-o", "test", "-L#{opt_lib}", "-lzoltan"
    system "./test"
  end
end
