class Madlib < Formula
  desc "Library for scalable in-database analytics."
  homepage "https://madlib.incubator.apache.org/"
  url "https://github.com/apache/madlib/archive/rel/v1.12.tar.gz"
  sha256 "4f21b1f463f22ee7ddefbe2e4c52e254a7156aefef980f1b3f26479f5f8c1672"
  head "https://github.com/apache/madlib.git"

  bottle do
    sha256 "2b3b00b26a10a1a91c47b5110f97584ffa5fd3c32a0187d23af2c842b23840e4" => :sierra
    sha256 "e2e20a7dabb02a1912685611f5cf2481a91794b6f4396a94b07b286815b8bffd" => :el_capitan
    sha256 "307cb968d0799c3ac75db9cbfe691f2be89dd4170dcf3814df0b71be0f9d742b" => :yosemite
  end

  boost_opts = []
  boost_opts << "c++11" if MacOS.version < :mavericks
  depends_on "boost@1.59" => boost_opts
  depends_on "boost-python@1.59" => boost_opts if build.with? "python"
  depends_on "cmake" => :build
  depends_on "postgresql" => ["with-python"]
  depends_on :python => :optional

  resource "pyxb" do
    url "https://downloads.sourceforge.net/project/pyxb/pyxb/1.2.4/PyXB-1.2.4.tar.gz"
    sha256 "024f9d4740fde187cde469dbe8e3c277fe522a3420458c4ba428085c090afa69"
  end

  resource "eigen" do
    url "https://bitbucket.org/eigen/eigen/get/3.2.10.tar.gz"
    sha256 "04f8a4fa4afedaae721c1a1c756afeea20d3cdef0ce3293982cf1c518f178502"
  end

  fails_with :clang do
    build 503
    cause "See http://jira.madlib.net/browse/MADLIB-865"
  end

  fails_with :gcc do
    build 5666
    cause "See http://jira.madlib.net/browse/MADLIB-865"
  end

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
