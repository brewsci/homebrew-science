class Plr < Formula
  desc "PL/R - R Procedural Language for PostgreSQL"
  homepage "https://www.joeconway.com/plr.html"
  url "https://github.com/postgres-plr/plr/archive/REL8_3_0_17.tar.gz"
  sha256 "256ed6666ec93d6bd5c166904a3233dd4b872bb1652db5c3abbea714ad7f2d77"
  head "https://github.com/postgres-plr/plr.git"

  bottle do
    sha256 "f0523bd627bd88289063e126e11550dd1886c33a53c7e4d5a125325f01f06262" => :sierra
    sha256 "d4fad1caca9998ca0f9f5daf34b26d6861e3f2b62e36dcaf4a07fd84a49a8aae" => :el_capitan
    sha256 "e003f96fd5bb30bbd6d751eb18c233805d06fec61506aba7d6eb7c67d7a77007" => :yosemite
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
