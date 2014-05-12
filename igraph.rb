require 'formula'

class Igraph < Formula
  homepage 'http://igraph.org'
  url 'http://igraph.org/nightly/get/c/igraph-0.7.1.tar.gz'
  sha1 '2cf3528a60c52810a3d5ed9f117692f8f639aac1'

  option :universal

  # GMP is optional, and doesn't have a universal build
  depends_on 'gmp' => :optional unless build.universal?

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    # Adapted from http://igraph.org/c/doc/igraph-tutorial.html
    (testpath/"igraph_test.c").write <<-EOS.undent
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
