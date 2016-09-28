class Madlib < Formula
  desc "Library for scalable in-database analytics."
  homepage "https://madlib.incubator.apache.org/"
  url "https://github.com/apache/incubator-madlib/archive/rel/v1.9.1.tar.gz"
  sha256 "60ffb6bb2c41895330e62b3eea135ebdd42ac88c34db9f016a151795b3dbbcbc"
  head "https://github.com/apache/incubator-madlib.git"

  bottle do
    sha256 "71f051842a24ba554179392c649e0f0bf8f6ba2d86a384a02f030beac833c5d8" => :el_capitan
    sha256 "58e344a0e6ce85c91f0449108fda4b162771ac180dd3f603f1309aab7fde1a73" => :yosemite
    sha256 "f3055c16600f8e90932783bd0ae7cde57e104619e241d6ea5245f227ba06f95d" => :mavericks
  end

  boost_opts = []
  boost_opts << "c++11" if MacOS.version < :mavericks
  depends_on "boost" => boost_opts
  depends_on "boost-python" => boost_opts if build.with? "python"
  depends_on "cmake" => :build
  depends_on "postgresql" => ["with-python"]
  depends_on :python => :optional

  resource "pyxb" do
    url "https://downloads.sourceforge.net/project/pyxb/pyxb/1.2.4/PyXB-1.2.4.tar.gz"
    sha256 "024f9d4740fde187cde469dbe8e3c277fe522a3420458c4ba428085c090afa69"
  end

  resource "eigen" do
    url "https://bitbucket.org/eigen/eigen/get/3.2.2.tar.gz"
    sha256 "318d68c5a9c20ec20d08f1a50a10fb4991a25fd5474a969e771cd9f2a79c9e5f"
  end

  fails_with :clang do
    build 503
    cause "See http://jira.madlib.net/browse/MADLIB-865"
  end

  fails_with :gcc do
    build 5666
    cause "See http://jira.madlib.net/browse/MADLIB-865"
  end

  # See https://github.com/apache/incubator-madlib/pull/76
  patch :DATA

  def install
    # http://jira.madlib.net/browse/MADLIB-913
    ENV.libstdcxx if ENV.compiler == :clang

    resource("pyxb").fetch
    resource("eigen").fetch

    args = %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DCMAKE_BUILD_TYPE=Release
      -DPYXB_TAR_SOURCE=#{resource("pyxb").cached_download}
      -DEIGEN_TAR_SOURCE=#{resource("eigen").cached_download}
    ]
    system "./configure", *args
    system "make", "install"

    # Replace symlink with real directory
    bin.delete
    bin.mkdir
    # MADlib has an unusual directory structure: bin is a symlink
    # to Current/bin, which in turn is a symlink to
    # Versions/<current version>/bin. Homebrew won't link
    # bin/madpack and, even if it did, madpack would not find
    # its dependencies. Hence, we create a shim script.
    bin.write_exec_script("#{prefix}/Current/bin/madpack")
  end

  def caveats; <<-EOS.undent
    MADlib must be rebuilt if you upgrade PostgreSQL:

      brew reinstall madlib
    EOS
  end

  test do
    # The following fails if madpack cannot find its dependencies.
    system "#{bin}/madpack", "-h"

    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55562"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork { exec "#{pg_bin}/postgres", "-D", testpath/"test", "-p", pg_port }

    begin
      sleep 2
      system "#{pg_bin}/createdb", "-p", pg_port, "test_madpack"
      system "#{bin}/madpack", "-p", "postgres", "-c", "#{ENV["USER"]}/@localhost:#{pg_port}/test_madpack", "install"
      system "#{bin}/madpack", "-p", "postgres", "-c", "#{ENV["USER"]}/@localhost:#{pg_port}/test_madpack", "install-check"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end

__END__
diff --git a/src/dbal/BoostIntegration/MathToolkit_impl.hpp b/src/dbal/BoostIntegration/MathToolkit_impl.hpp
index 2239f14..a83b421 100644
--- a/src/dbal/BoostIntegration/MathToolkit_impl.hpp
+++ b/src/dbal/BoostIntegration/MathToolkit_impl.hpp
@@ -11,6 +11,7 @@

 #include <iomanip>

+#include <boost/format.hpp>
 #include <boost/math/policies/error_handling.hpp>

 namespace boost {
