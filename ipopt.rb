class Ipopt < Formula
  desc "Large-scale nonlinear optimization package"
  homepage "https://projects.coin-or.org/Ipopt"
  url "http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.5.tgz"
  sha256 "53e7af6eefcb6de1f8e936c9c887c7bcb5a9fa4fcf7673a227f16de131147325"
  head "https://projects.coin-or.org/svn/Ipopt/trunk", using: :svn

  bottle do
    cellar :any
    sha256 "8a062e28570c0a66fcefdc5109855d3e26f68beadea9763346a1680cc3772ff2" => :el_capitan
    sha256 "f82ae72c4083adba2511fdcef19794e27e6d65c13e8fa221f38187300170ddab" => :yosemite
    sha256 "81fd7abec9c258763401984eca14ca3abe53a9c611f1ed9ec15be4b8510b71c1" => :mavericks
  end

  option "without-test", "Skip build-time tests (not recommended)"
  deprecated_option "without-check" => "without-test"

  depends_on "asl" => :recommended
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

    if build.with? "asl"
      args << "--with-asl-incdir=#{Formula["asl"].opt_include}/asl"
      args << "--with-asl-lib=-L#{Formula["asl"].opt_lib} -lasl"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Needs a serialized install
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    # IPOPT still fails to converge on the Waechter-Biegler problem?!?!
    system "#{bin}/ipopt", "#{Formula["asl"].opt_share}/asl/example/examples/wb" if build.with? "asl"
  end
end
