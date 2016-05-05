class Plr < Formula
  desc "PL/R - R Procedural Language for PostgreSQL"
  homepage "http://www.joeconway.com/plr/"
  url "https://github.com/jconway/plr/archive/REL8_3_0_16.tar.gz"
  sha256 "57e2384f7b51328c9e6d92a40039cae7ac3e187ece03a1d33985b751f24bfe18"
  head "https://github.com/jconway/plr.git"
  revision 1

  bottle do
    sha256 "b6f5282a588ba7135b312956ad2d8b54add69b8acbfbe680afa8273b6a580b7d" => :el_capitan
    sha256 "aa4371217ab3dedf99f8809c8bfb96f54b50e50861a8dfd74e5af00f86b96a34" => :yosemite
    sha256 "008223fc252868df8435fc23fe69bbd55a0dc5a90c926fb156a7fc5f38bc300f" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "postgresql"
  depends_on "r"

  def install
    ENV["USE_PGXS"] = "1"
    pg_config = "#{Formula["postgresql"].opt_bin}/pg_config"
    system "make", "PG_CONFIG=#{pg_config}"
    mkdir "stage"
    system "make", "DESTDIR=#{buildpath}/stage", "PG_CONFIG=#{pg_config}", "install"
    lib.install Dir["stage/**/lib/*"]
    (doc/"postgresql/extension").install Dir["stage/**/share/doc/postgresql/extension/*"]
    (share/"postgresql/extension").install Dir["stage/**/share/postgresql/extension/*"]
  end

  test do
    pg_bin = Formula["postgresql"].opt_bin
    pg_port = "55561"
    system "#{pg_bin}/initdb", testpath/"test"
    pid = fork { exec "#{pg_bin}/postgres", "-D", testpath/"test", "-p", pg_port }

    begin
      sleep 2
      system "#{pg_bin}/createdb", "-p", pg_port
      system "#{pg_bin}/psql", "-p", pg_port, "--command", "CREATE DATABASE test;"
      system "#{pg_bin}/psql", "-p", pg_port, "-d", "test", "--command", "CREATE EXTENSION plr;"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
