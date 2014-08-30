require "formula"

class Madlib < Formula
  homepage "http://madlib.net"
  url "https://github.com/madlib/madlib/archive/v1.6.0.tar.gz"
  sha1 "c19867f71f85d6dcb83b4600a811530a9344cc35"
  revision 1

  head "https://github.com/madlib/madlib.git", :branch => "master"

  boost_opts = []
  boost_opts << "c++11" if MacOS.version < :mavericks
  depends_on "boost" => boost_opts
  depends_on "boost-python" => boost_opts if build.with? "python"
  depends_on "cmake" => :build
  depends_on "postgresql" => ['with-python']
  depends_on :python => :optional

  fails_with :clang do
    build 503
    cause "See http://jira.madlib.net/browse/MADLIB-865"
  end

  fails_with :gcc do
    build 5666
    cause "See http://jira.madlib.net/browse/MADLIB-865"
  end

  fails_with :llvm do
    build 5666
    cause "See http://jira.madlib.net/browse/MADLIB-865"
  end

  # MADlib has an unusual directory structure: bin is a symlink
  # to Current/bin, which in turn is a symlink to
  # Versions/<current version>/bin. Homebrew won't link
  # bin/madpack and, even if it did, madpack would not find
  # its dependencies. Hence, we define a shim script.
  def shim_script target
    <<-EOS.undent
      #!/bin/bash
      exec "#{prefix}/Current/bin/#{target}" "$@"
    EOS
  end

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release"
    ]
    system "./configure", *args
    system "make install"

    # Replace symlink with real directory
    bin.delete
    bin.mkdir
    (bin+"madpack").write shim_script("madpack")
  end

  def caveats; <<-EOS.undent
    MADlib must be rebuilt if you upgrade PostgreSQL:

      brew reinstall madlib
    EOS
  end

  test do
    # The following fails if madpack cannot find its dependencies.
    system "#{bin}/madpack", "-h"
    pg_bin = Formula["postgresql"].bin
    # Start PostgreSQL server if it is not already running
    if File.exists?("#{var}/postgres/postmaster.pid")
      pg_running = true
    else
      pg_running = false
      system "launchctl load /usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist"
      sleep(5) # Wait for the server to start
    end
    system "#{pg_bin}/createdb -w -U #{ENV['USER']} test_madpack"
    begin
      system "#{bin}/madpack -p postgres -c #{ENV['USER']}/@localhost/test_madpack install"
      system "#{bin}/madpack -p postgres -c #{ENV['USER']}/@localhost/test_madpack install-check"
    ensure # clean up
      system "#{pg_bin}/dropdb -w -U #{ENV['USER']} test_madpack"
      system "launchctl unload /usr/local/opt/postgresql/homebrew.mxcl.postgresql.plist" unless pg_running
    end
  end
end
