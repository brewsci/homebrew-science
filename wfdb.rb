class Wfdb < Formula
  desc "A software library for working with physiologic signals"
  homepage "http://physionet.org/physiotools/"
  url "https://github.com/bemoody/wfdb/archive/10.5.24.tar.gz"
  sha256 "be3be34cd1c2c0eaaae56a9987de13f49a3c53bf1539ce7db58f885dc6e34b7b"
  head "https://github.com/bemoody/wfdb.git"

  bottle do
    sha256 "90a6785716be809f80a3d269b0d849b7b047a5b6979b15c82a843f09e980bbf8" => :yosemite
    sha256 "1bb573712810085ef699519126707d1236b92cdada363a4966f63bbf318d94cb" => :mavericks
    sha256 "0b8a7209b37e2c64f265cdc8bd7708d70997a3304b0098eadb479063ff719324" => :mountain_lion
  end

  def install
    ENV.deparallelize

    if build.head?
      # We need to set the package version manually, otherwise the configure script will prompt user for it...
      # We'll take the version from the NEWS file:
      news_version = %q(`head -1 ../NEWS | awk '{printf "wfdb-%s", $1}'`)
      inreplace "configure", /^PACKAGE=`.*`$/, "PACKAGE=#{news_version}"
    end

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"

    # Force compilation, prevent "install up to date"
    system "sh", "-c", "echo '.PHONY: install' >> Makefile"

    system "make", "install"

    pkgshare.install "examples", bin/"setwfdb", bin/"cshsetwfdb"

    # For some reason the configure script doesn't install the man pages properly
    # even though '--mandir' is used.
    share.install prefix/"man" if stable?
  end

  def caveats; <<-EOS.undent
    WFDB Example programs have been installed to:
      #{pkgshare}/examples
    EOS
  end

  test do
    cflags = `#{bin/"wfdb-config"} --cflags`.chomp
    libs = `#{bin/"wfdb-config"} --libs`.chomp
    system ENV.cc, cflags, "-o", "wfdbversion", pkgshare/"examples/wfdbversion.c", *libs.split
    system "./wfdbversion"
  end
end
