require "formula"

class Zoltan < Formula
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.81.tar.gz"
  homepage "http://www.cs.sandia.gov/Zoltan"
  sha1 "468c30db4b16cb16e5dde05fb951699e1e69527d"

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
      "CXX=#{`which mpic++`.chomp}",
    ]
    args << "--with-scotch"         if build.with? "scotch"
    args << "--with-parmetis"       if build.with? "parmetis"
    args << "--enable-f90interface" if build.with? "fortran"

    mkdir "zoltan-build" do
      system "../configure", *args
      system "make everything"
      system "make check" if build.with? "check"
      system "make install"
    end
  end
end
