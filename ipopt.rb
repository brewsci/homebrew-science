class Ipopt < Formula
  desc "Large-scale nonlinear optimization package"
  homepage "https://projects.coin-or.org/Ipopt"
  url "http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.4.tgz"
  sha256 "292afd952c25ec9fe6225041683dcbd3cb76e15a128764671927dbaf881c2e89"
  head "https://projects.coin-or.org/svn/Ipopt/trunk", :using => :svn

  bottle do
    cellar :any
    sha256 "a3003d876c82faf1284bb090f906ea60f278884298de304bc40a9adb44744d6c" => :el_capitan
    sha256 "298df60fe14c17f46a3c9c6cdd8be05e579ae0d734f40c1b31525724d89c8bad" => :yosemite
    sha256 "238fcb1f9c7b9a29e9777778b82b8d7aa6332be53335e5d4a8597adf220d7d5f" => :mavericks
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
