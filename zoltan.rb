class Zoltan < Formula
  homepage "http://www.cs.sandia.gov/Zoltan"
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.81.tar.gz"
  sha256 "9d6f2f9e2b37456cab7fe6714d51cd6d613374e915e6cc9f7fddcd72e3f38780"

  bottle do
    sha256 "133207543f781aa413062f7ecbe80b89e76b96577b62fe150727fa9f499a6d3c" => :yosemite
    sha256 "970454cab90e1c4ed9cccd2042c704d4122a4cfe59d5044d8b193bfcefe8fbe2" => :mavericks
    sha256 "d60f28375337061ea183d9e1112018498ad6dc33acbeaf5764a461b30ad797d5" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

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
    args << "--with-scotch"         if build.with? "scotch"
    args << "--with-parmetis"       if build.with? "parmetis"
    args += ["--enable-f90interface", "FC=#{ENV["MPIFC"]}"] if build.with? :fortran

    mkdir "zoltan-build" do
      system "../configure", *args
      system "make", "everything"
      system "make", "check" if build.with? "check"
      system "make", "install"
    end
  end
end
