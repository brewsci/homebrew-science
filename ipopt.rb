class Ipopt < Formula
  desc "Large-scale nonlinear optimization package"
  homepage "https://projects.coin-or.org/Ipopt"
  url "https://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.8.tgz"
  sha256 "62c6de314220851b8f4d6898b9ae8cf0a8f1e96b68429be1161f8550bb7ddb03"
  head "https://projects.coin-or.org/svn/Ipopt/trunk", :using => :svn

  bottle do
    cellar :any
    sha256 "ea5090d2a8e62db71fd8a4e99e48eb8c07fabc2df82209c905f53dea21247767" => :sierra
    sha256 "863173534de5020ac2a40f0c07550d01e510fd0f09d8f11bbe4ac9b9e7a2a835" => :el_capitan
    sha256 "399817abfafdc46c389b4ca36504dd12f7f0b4a5e36af35104d253ec3758e28b" => :yosemite
  end

  option "without-test", "Skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "ampl-mp" => :recommended
  depends_on "openblas" => :optional
  depends_on "pkg-config" => :build

  # IPOPT is not able to use parallel MUMPS.
  depends_on "mumps" => ["without-mpi"] + ((build.with? "openblas") ? ["with-openblas"] : [])

  depends_on :fortran

  def install
    ENV.delete("MPICC")  # configure will pick these up and use them to link
    ENV.delete("MPIFC")  # which leads to the linker crashing.
    ENV.delete("MPICXX")
    mumps_libs = %w[-ldmumps -lmumps_common -lpord -lmpiseq]
    mumps_incdir = Formula["mumps"].opt_libexec/"include"
    mumps_libcmd = "-L#{Formula["mumps"].opt_lib} " + mumps_libs.join(" ")

    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--with-mumps-incdir=#{mumps_incdir}",
            "--with-mumps-lib=#{mumps_libcmd}",
            "--enable-shared",
            "--enable-static"]

    if build.with? "openblas"
      args << "--with-blas-incdir=#{Formula["openblas"].opt_include}"
      args << "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas"
      args << "--with-lapack-incdir=#{Formula["openblas"].opt_include}"
      args << "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas"
    end

    if build.with? "ampl-mp"
      args << "--with-asl-incdir=#{Formula["ampl-mp"].opt_include}/asl"
      args << "--with-asl-lib=-L#{Formula["ampl-mp"].opt_lib} -lasl"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    # IPOPT still fails to converge on the Waechter-Biegler problem?!?!
    system "#{bin}/ipopt", "#{Formula["ampl-mp"].opt_pkgshare}/example/wb" if build.with? "ampl-mp"
  end
end
