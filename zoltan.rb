class Zoltan < Formula
  homepage "http://www.cs.sandia.gov/Zoltan"
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.81.tar.gz"
  sha256 "9d6f2f9e2b37456cab7fe6714d51cd6d613374e915e6cc9f7fddcd72e3f38780"

  bottle do
    sha1 "911518dee35a199273a11d1668d4140ea06318ad" => :yosemite
    sha1 "2104491320085f55c4f5dd1d35d4272f79b41e0c" => :mavericks
    sha1 "2cd96dfa01e36114ba11b2ae126fdf0a3ee30041" => :mountain_lion
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
