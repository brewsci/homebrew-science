class Ipopt < Formula
  desc "Large-scale nonlinear optimization package"
  homepage "https://projects.coin-or.org/Ipopt"
  url "http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.5.tgz"
  sha256 "53e7af6eefcb6de1f8e936c9c887c7bcb5a9fa4fcf7673a227f16de131147325"
  head "https://projects.coin-or.org/svn/Ipopt/trunk", :using => :svn
  revision 1

  bottle do
    cellar :any
    sha256 "8fd21f3fc02a89b05de121fde1ad91f8cc2ee333e2256008837d8581e7fe9840" => :sierra
    sha256 "a1de12618e1de406317bea05c6a848373b764b3b10d4c294c660a5fde2f10cef" => :el_capitan
    sha256 "511d4fdf8a74bfffc83adecacf42869c0831274283a94fd30bf27a7606b2247b" => :yosemite
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
    system "#{bin}/ipopt", "#{Formula["ampl-mp"].opt_pkgshare}/example/examples/wb" if build.with? "ampl-mp"
  end
end
