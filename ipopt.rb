class Ipopt < Formula
  homepage "https://projects.coin-or.org/Ipopt"
  url "http://www.coin-or.org/download/source/Ipopt/Ipopt-3.12.1.tgz"
  sha1 "cbb197f6a90e0e1d64e438a5159da5f33f06aa08"
  head "https://projects.coin-or.org/svn/Ipopt/trunk", :using => :svn
  revision 2

  bottle do
    root_url "https://homebrew.bintray.com/bottles-science"
    sha256 "8374352edbab068e3c262a256e31e8d9feabcdcdd4120bb9a8b6c210d997142c" => :yosemite
    sha256 "d7dfea0ed738381ee2ef7d28fbb34ade36ca923313d7930e56b66658b4fcf65c" => :mavericks
    sha256 "a8f6890e64f548c2465bb18ce967b88e7a1f3d41051747aabbe32c6be564f671" => :mountain_lion
  end

  option "without-check", "Skip build-time tests (not recommended)"

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
    mumps_incdir = Formula["mumps"].libexec / "include"
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
    system "make", "test" if build.with? "check"
    system "make", "install"
  end

  test do
    # IPOPT still fails to converge on the Waechter-Biegler problem?!?!
    system "#{bin}/ipopt", "#{Formula["asl"].opt_share}/asl/example/examples/wb" if build.with? "asl"
  end
end

