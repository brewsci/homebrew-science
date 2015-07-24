class Igraph < Formula
  homepage "http://igraph.org"
  url "http://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz"
  sha256 "d978030e27369bf698f3816ab70aa9141e9baf81c56cc4f55efbe5489b46b0df"

  bottle do
    cellar :any
    sha256 "a0e438be157ccc4ad4658a40a5c28f468ffc865a8f4d7cde4869df655799d481" => :yosemite
    sha256 "020801feed2868e70736ce34946f00934d324774ed9de4dc28dcaa994b2ec0df" => :mavericks
    sha256 "b9110e6a58fe00a5aae8648d04d530fba303c3a9fc7daecac8b817bd6c18e799" => :mountain_lion
  end

  option :universal

  # Use Homebrew Arpack, but disable thread-local storage.
  # If not selected, iGraph uses a built-in Arpack.
  depends_on "arpack" => :optional

  # GMP is optional, and doesn't have a universal build
  depends_on "gmp" => :optional unless build.universal?

  depends_on "glpk" => :recommended

  def install
    ENV.universal_binary if build.universal?

    # There doesn't seem to be a way to specify which BLAS/LAPACK, ARPACK or GPLK.
    # iGraph just looks for -lblas, -llapack, -larpack and -lglpk on the path.
    extra_opts = ["--with-external-blas", "--with-external-lapack"]
    extra_opts << ((build.with? "glpk") ? "--with-external-glpk" : "--disable-glpk")
    extra_opts << "--disable-gmp" if build.without? "gmp"
    extra_opts += ["--with-external-arpack", "--disable-tls"] if build.with? "arpack"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          *extra_opts
    system "make", "install"
  end

  test do
    # Adapted from http://igraph.org/c/doc/igraph-tutorial.html
    (testpath / "igraph_test.c").write <<-EOS.undent
      #include <igraph.h>

      int main(void)
      {
          igraph_integer_t diameter;
          igraph_t graph;
          return 0;
      }
      EOS
    system ENV.cc, "igraph_test.c", "-I#{include}/igraph", "-L#{lib}",
                   "-ligraph", "-o", "igraph_test"
    system "./igraph_test"
  end
end
